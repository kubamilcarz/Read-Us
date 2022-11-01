//
//  UpdateBookProgressSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct UpdateBookProgressSheet: View {
    @EnvironmentObject var mainVM: MainViewModel
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    
    @State private var numberOfPagesToAdd = ""
    @State private var numberOfPagesToAddInt: Double = 0
    @State private var note = ""
    
    var updateDisabled: Bool {
        Int(numberOfPagesToAddInt) == mainVM.getCurrentPage(for: book) || Int(numberOfPagesToAddInt) > book.number_of_pages || numberOfPagesToAddInt < 0
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    Group {
                        updateProgressForm
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $note)
                                .frame(minHeight: 120, maxHeight: 160)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.secondary)
                                        .opacity(0.7)
                                        .zIndex(6)
                                )
                                .padding(2)
                            
                            if note.count == 0 {
                                Text("Add a note")
                                    .foregroundStyle(.secondary)
                                    .allowsHitTesting(false)
                                    .offset(x: 11, y: 14)
                            }
                        }
                    }
                }
                .padding()
                
                HStack(spacing: 15) {
                    Button(action: finishBook) {
                        Text("Finish")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .zIndex(3)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: updateProgress) {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(updateDisabled)
                }
                .controlSize(.small)
                .tint(.ruAccentColor)
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Update Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                .tint(.secondary)
            }
        }
        .onAppear {
            numberOfPagesToAdd = "\(mainVM.getCurrentPage(for: book))"
            numberOfPagesToAddInt = Double(mainVM.getCurrentPage(for: book))
        }
        .onChange(of: numberOfPagesToAddInt) { _ in
            numberOfPagesToAdd = String(Int(numberOfPagesToAddInt))
        }
        .onChange(of: numberOfPagesToAdd) { _ in
            numberOfPagesToAddInt = Double(numberOfPagesToAdd) ?? 0
        }
    }
    
    private var updateProgressForm: some View {
        VStack(spacing: 15) {
            Slider(value: $numberOfPagesToAddInt, in: 0 ... Double(book.number_of_pages), step: 1) { _ in
                withAnimation {
                    numberOfPagesToAdd = String(Int(numberOfPagesToAddInt))
                }
            }
            .tint(.ruAccentColor)
            
            HStack {
                Text("Where are you?")
                Spacer()
                HStack {
                    TextField("\(book.numberOfPages)", text: $numberOfPagesToAdd)
                        .keyboardType(.numberPad)
                        .frame(width: 70)
                        .textFieldStyle(.roundedBorder)
                    Text("/ \(book.numberOfPages)")
                }
            }
        }
    }
    
    private func updateProgress() {
        withAnimation {
            if let pages = Int(numberOfPagesToAdd) {
                if pages >= book.number_of_pages {
                    // book should be marked as read
                    mainVM.finish(moc: moc, book: book)
                } else if pages <= 0 {
                    // book has 50 pages
                    // was at 20
                    // updated to -30
                    mainVM.updateProgress(moc: moc, for: book, pages: 0, notes: note)
                } else {
                    mainVM.updateProgress(moc: moc, for: book, pages: pages, notes: note)
                }
                
                dismiss()
            }
        }
    }
    
    private func finishBook() {
        withAnimation {
            mainVM.finish(moc: moc, book: book)
            dismiss()
        }
    }
}
