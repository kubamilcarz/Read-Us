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
    @EnvironmentObject var mainVM: MainViewModel
    
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
            return CGFloat(mainVM.getCurrentPage(for: book)) / CGFloat(book.numberOfPages)
        }
    }
    
    var readingTime: Double {
        Double(book.safeFinishedReadingOn.timeIntervalSince(book.safeStartedReadingOn)) / 86_400
    }
    
    // determine overlays
    var stoppedReading: Bool { book.isReading == false && book.isRead == false && book.safeEntries.isEmpty == false }
    var isNewBook: Bool { book.isReading == false && book.isRead == false && book.safeEntries.isEmpty }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack(alignment: .top, spacing: isEditModeOn ? 8 : 15) {
                    ZStack {
                        BookPhotoCell(for: book.safePhoto, width: 100)
                        
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
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            Group {
                                if isEditModeOn {
                                    TextField(book.safeTitle, text: $title)
                                        .textFieldStyle(.roundedBorder)
                                } else { Text(book.safeTitle) }
                            }
                            .font(.system(.title3, design: .serif)).bold()
                            
                            Group {
                                if isEditModeOn {
                                    TextField(book.safeAuthor, text: $author)
                                        .textFieldStyle(.roundedBorder)
                                } else { Text(book.safeAuthor) }
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
                        
                        if !isNewBook && !stoppedReading && !isEditModeOn {
                            StarRatingCell(for: book)
                        }
                        
                        if !isEditModeOn {
                            VStack {
                                Spacer()
                                
                                readingStatusOverlays
                                
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Spacer()
                        }
                    }
                }
                
                if book.isRead {
                    Divider()
                    
                    HStack {
                        Text("You finished this book on \(book.safeFinishedReadingOn.formatted(date: .abbreviated, time: .omitted)) and it took you \(readingTime) days.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
                
                Divider()
                
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
            title = book.safeTitle
            author = book.safeAuthor
            
            startDate = book.safeStartedReadingOn
            finishDate = book.safeFinishedReadingOn
        }
        
        .onChange(of: photoSelection) { newValue in
            Task {
                if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                    uiImage = image
                    photo = Image(uiImage: image)
                    
                    book.photo = uiImage?.jpegData(compressionQuality: 1.0) ?? Data()
                    
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
    
    private var editModeButton: some View {
        Button(isEditModeOn ? "Done" : "Edit") {
            withAnimation {
                isEditModeOn.toggle()
                
                if isEditModeOn == false {
                    // update title and author
                    book.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    book.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if book.isRead && !book.isReading {
                        book.startedReadingOn = startDate
                        book.finishedReadingOn = finishDate
                    }
                    try? moc.save()
                }
            }
        }
    }
    
    private var readingStatusOverlays: some View {
        Group {
            if book.isRead {
                Button {
                    mainVM.resetProgress(moc: moc, for: book)
                } label: {
                    Text("Read it Again")
                        .font(.caption2)
                }
                .buttonStyle(.bordered)
                .clipShape(Capsule())
            } else {
                ZStack {
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
                    
                    if stoppedReading {
                        VStack {
                            Text("You stopped reading this book")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                            HStack {
                                Button("Cancel", role: .destructive) {
                                    mainVM.resetProgress(moc: moc, for: book)
                                }
                                .font(.system(size: 12))
                                
                                Button("Resume") {
                                    book.isReading = true
                                    try? moc.save()
                                }
                                .font(.system(size: 12))
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    
                    if isNewBook {
                        VStack {
                            Text("Start reading this book")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                            HStack {
                                Button("Read Later") {
                                    
                                }
                                .font(.system(size: 12))
                                
                                Button("Start") {
                                    book.isReading = true
                                    try? moc.save()
                                }
                                .font(.system(size: 12))
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
            }
        }
    }
}
