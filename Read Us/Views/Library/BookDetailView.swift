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
                HStack(alignment: .top, spacing: 15) {
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
                            Text(book.safeTitle)
                                .font(.system(.title3, design: .serif)).bold()
                            
                            Text(book.safeAuthor)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if !isNewBook && !stoppedReading {
                            StarRatingCell(for: book)
                        }
                        
                        VStack {
                            Spacer()
                            
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
                            
                            Spacer()
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
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Notes")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    Text(book.safeNotes)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            editModeButton
        }
        .sheet(isPresented: $isShowingUpdateProgressSheet) {
            UpdateBookProgressSheet(book: book)
                .presentationDetents([.height(220)])
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
            }
        }
        .tint(.secondary)
    }
}
