//
//  BookDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import PhotosUI
import SwiftUI

struct BookDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataManager: DataManager
    
    var book: Book
    
    @State private var isEditModeOn = false
    @State private var isShowingUpdateProgressSheet = false
    
    @State private var photoSelection: PhotosPickerItem?
    @State private var photo: Image?
    @State private var uiImage: UIImage?
    
    @State private var title = ""
    @State private var author = ""
    
    @State private var startDate = Date.now
    @State private var finishDate = Date.now
    
    var bookProgress: CGFloat {
        if book.isRead {
            return 1.0
        } else {
            return CGFloat(dataManager.getCurrentPage(for: book)) / CGFloat(book.numberOfPages)
        }
    }
    
    // determine overlays
    var stoppedReading: Bool { book.isReading == false && book.isRead == false && book.bookUpdatesArray.isEmpty == false }
    var isNewBook: Bool { book.isReading == false && book.isRead == false && book.bookUpdatesArray.isEmpty }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack(alignment: .top, spacing: isEditModeOn ? 8 : 15) {
                    bookPhotoEditable
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bookHeadlinesWithEditing
                        
                        if !isEditModeOn {
                            StarRatingCell(for: book)
                        }
                        
                        if !isEditModeOn && book.isReading {
                            bookProgressBar
                        }
                        
                        HStack { Spacer() }
                    }
                }
                
                BookDetailShelvesBar(book: book)
                
                BookDetailReadingStatus(book: book)
                
                BookDetailReadings(book: book)
                
                BookDetailNotesView(book: book)
            }
            .padding()
            .padding(.bottom, 75)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            editModeButton
        }
        .sheet(isPresented: $isShowingUpdateProgressSheet) {
            UpdateBookProgressSheet(book: book)
                .presentationDetents([.medium])
        }
        
        .onAppear {
            title = book.title_string
            author = book.author_string
            
            startDate = book.bookReadingsArray.first?.date_started ?? Date.now
            finishDate = book.bookReadingsArray.first?.date_finished ?? Date.now
        }
        
        .onChange(of: photoSelection) { newValue in
            Task {
                if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                    uiImage = image
                    photo = Image(uiImage: image)
                    
                    book.cover = uiImage?.jpegData(compressionQuality: 1.0) ?? Data()
                    
                    try? moc.save()
                    
                    isEditModeOn = false
                }
            }
        }
        .onChange(of: isShowingUpdateProgressSheet) { _ in
            withAnimation {
                moc.refresh(book, mergeChanges: true)
            }
        }
    }
    
    private var bookPhotoEditable: some View {
        ZStack {
            BookPhotoCell(for: book.cover, width: 100)
            
            if isEditModeOn {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                
                PhotosPicker(selection: $photoSelection) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title)
                        .foregroundColor(.primary)
                }
            }
        }
        .aspectRatio(3/5, contentMode: .fill)
        .frame(width: 100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
                .foregroundColor(.secondary)
        )
    }
    
    private var bookHeadlinesWithEditing: some View {
        VStack(alignment: .leading, spacing: 3) {
            Group {
                if isEditModeOn {
                    TextField(book.title_string, text: $title)
                        .textFieldStyle(.roundedBorder)
                } else { Text(book.title_string) }
            }
            .font(.system(.title3, design: .serif)).bold()
            
            Group {
                if isEditModeOn {
                    TextField(book.author_string, text: $author)
                        .textFieldStyle(.roundedBorder)
                } else { Text(book.author_string) }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            if isEditModeOn && book.isRead && !book.isReading {
                HStack(spacing: 5) {
                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                    
                    Text("–").foregroundColor(.secondary)
                    
                    DatePicker("Finish", selection: $finishDate, in: startDate..., displayedComponents: .date)
                }
                .labelsHidden()
                .padding(.top, 15)
            }
        }
        .offset(y: isEditModeOn ? -5 : 0)
    }
    
    private var bookProgressBar: some View {
        VStack(alignment: .trailing, spacing: 10) {
            CustomProgressView(value: bookProgress)
            Button {
                isShowingUpdateProgressSheet = true
            } label: {
                Text("Update Progress")
                    .font(.caption2)
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        }
    }
    
    private var editModeButton: some View {
        Button(isEditModeOn ? "Done" : "Edit") {
            withAnimation {
                isEditModeOn.toggle()
                
                if isEditModeOn == false {
                    // update title and author
                    book.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    book.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if book.isRead && !book.isReading {
                        let latestRead = dataManager.getLatestBookReading(for: book)
                        
                        latestRead?.dateStarted = startDate
                        latestRead?.dateFinished = finishDate
                        
//                        book.startedReadingOn = startDate
//                        book.finishedReadingOn = finishDate
                    }
                    try? moc.save()
                }
            }
        }
    }
}
