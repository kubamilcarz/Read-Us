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
    
    var newProgress: CGFloat {
        CGFloat(mainVM.getCurrentPage(for: book)) / CGFloat(book.numberOfPages)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    updateProgressForm
                }
                .padding()
                
                HStack(spacing: 15) {
                    Button(action: finishBook) {
                        Text("Finish")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: updateProgress) {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .controlSize(.small)
                .tint(.ruAccentColor)
                .padding()
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
    }
    
    private var updateProgressForm: some View {
        VStack(spacing: 15) {
//            CustomProgressView(value: newProgress)
            Slider(value: $numberOfPagesToAddInt, in: 0 ... Double(book.safeNumberOfPages), step: 1) { _ in
                withAnimation {
                    numberOfPagesToAdd = "\(Int(numberOfPagesToAddInt))"
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
                if pages >= book.safeNumberOfPages {
                    // book should be marked as read
                    mainVM.finish(moc: moc, book: book)
                } else if pages <= 0 {
                    // book has 50 pages
                    // was at 20
                    // updated to -30
                    mainVM.updateProgress(moc: moc, for: book, pages: 0)
                } else {
                    mainVM.updateProgress(moc: moc, for: book, pages: pages)
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
