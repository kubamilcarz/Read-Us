//
//  UpdateBookProgressSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct UpdateBookProgressSheet: View {
    @EnvironmentObject var dataManager: DataManager
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    
    @State private var numberOfPagesToAdd = ""
    @State private var numberOfPagesToAddInt: Double = 0
    @State private var note = ""
    @State private var isFinishedButtonClicked = false
    
    @State private var startedDate = Date.now
    @State private var finishedDate = Date.now
    @State private var review = ""
    @State private var rating = 0
    
    var updateDisabled: Bool {
        Int(numberOfPagesToAddInt) == dataManager.getCurrentPage(for: book) || Int(numberOfPagesToAddInt) > book.number_of_pages || numberOfPagesToAddInt < 0
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    if isFinishedButtonClicked == false {
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
                        .background(.background)
                        .transition(.push(from: isFinishedButtonClicked ? SwiftUI.Edge.leading : SwiftUI.Edge.trailing))
                    } else {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Reading Dates")
                                
                                Spacer()
                                
                                DatePicker("Started on", selection: $startedDate, in: ...finishedDate, displayedComponents: .date)
                                    .labelsHidden()
                                
                                Text(" - ")
                                    .foregroundColor(.secondary)
                                
                                DatePicker("Finished on", selection: $finishedDate, in: startedDate..., displayedComponents: .date)
                                    .labelsHidden()
                            }
                            
                            HStack {
                                Text("Rating")
                                
                                Spacer()
                                
                                StarRatingCell(for: $rating)
                            }
                            .padding(.vertical)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $review)
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
                                
                                if review.count == 0 {
                                    Text("Write a review")
                                        .foregroundStyle(.secondary)
                                        .allowsHitTesting(false)
                                        .offset(x: 11, y: 14)
                                }
                            }
                        }
                        .background(.background)
                        .transition(.push(from: isFinishedButtonClicked ? SwiftUI.Edge.leading : SwiftUI.Edge.trailing))
                    }
                }
                .padding()
                
                HStack(spacing: 15) {
                    Button {
                        if isFinishedButtonClicked {
                            finishBook()
                        } else {
                            withAnimation { isFinishedButtonClicked = true }
                        }
                        
                    } label: {
                        Text("Finish")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .zIndex(3)
                    }
                    .buttonStyle(.bordered)
                    
                    if !isFinishedButtonClicked {
                        Button(action: updateProgress) {
                            Text("Update")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 7)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(updateDisabled)
                    }
                }
                .controlSize(.small)
                .tint(.ruAccentColor)
                .padding([.horizontal, .bottom])
            }
            .navigationTitle(isFinishedButtonClicked ? "Book Finished" : "Update Progress")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isFinishedButtonClicked {
                        Button {
                            withAnimation { isFinishedButtonClicked = false }
                        } label: {
                            Label("Go Back", systemImage: "arrow.left")
                        }
                    }
                }
            }
        }
        .onAppear {
            numberOfPagesToAdd = "\(dataManager.getCurrentPage(for: book))"
            numberOfPagesToAddInt = Double(dataManager.getCurrentPage(for: book))
            
            startedDate = dataManager.getCurrentBookReading(for: book)?.date_started ?? Date.now
            
            rating = dataManager.getCurrentBookReading(for: book)?.rating_int ?? 0
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
                    dataManager.finish(moc: moc, book: book)
                } else if pages <= 0 {
                    // book has 50 pages
                    // was at 20
                    // updated to -30
                    dataManager.updateProgress(moc: moc, for: book, pages: 0, notes: note)
                } else {
                    dataManager.updateProgress(moc: moc, for: book, pages: pages, notes: note)
                }
                
                dismiss()
            }
        }
    }
    
    private func finishBook() {
        withAnimation {
            let currentRead = dataManager.getCurrentBookReading(for: book)
            currentRead?.review = review
            currentRead?.rating = Int64(rating)
            currentRead?.dateStarted = startedDate
            currentRead?.dateFinished = finishedDate
            currentRead?.isReading = false
            
            dataManager.finish(moc: moc, book: book)
        }
        
        dismiss()
    }
}
