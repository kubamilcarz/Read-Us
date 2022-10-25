//
//  BookGrid.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/11/22.
//

import SwiftUI

struct BookGrid: View {
    @Environment(\.managedObjectContext) var moc
    
    var books: [Book]
    
    @Binding var isEditModeOn: Bool
    @Binding var isShowingLibraryChoser: Bool
    
    var shelf: Shelf?
    
    init(books: [Book], isEditModeOn: Binding<Bool>, isShowingLibraryChoser: Binding<Bool>, shelf: Shelf? = nil) {
        self.books = books
        self._isEditModeOn = isEditModeOn
        self._isShowingLibraryChoser = isShowingLibraryChoser
        
        self.shelf = shelf
    }
    
    @State private var bookToUpdate: Book?
    @State private var bookToRemove: Book?
    @State private var isShowingNewShelfSheet = false
    @State private var isShowingConfirmation = false
    
    @FetchRequest<Shelf>(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var shelves: FetchedResults<Shelf>
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 15)], alignment: .leading) {
            ForEach(books) { book in
                NavigationLink {
                    BookDetailView(book: book)
                } label: {
                    bookCell(book: book)
                }
                .tint(.primary)
                .contextMenu {
                    bookContextMenu(book: book)
                }
            }
            
            if !isEditModeOn && shelf != nil { addBookButton }
        }
        .confirmationDialog("Are you sure?", isPresented: $isShowingConfirmation, actions: {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                withAnimation {
                    if let shelf, isEditModeOn {
                        bookToRemove?.removeFromShelves(shelf)
                        try? moc.save()
                    }
                    
                    if shelf == nil && isEditModeOn {
                        if let bookToRemove {
                            moc.delete(bookToRemove)
                            try? moc.save()
                        }
                    }
                }
            }
        })
        
        .sheet(item: $bookToUpdate, content: { _ in
            if let bookToUpdate {
                UpdateBookProgressSheet(book: bookToUpdate)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        })
        .sheet(isPresented: $isShowingNewShelfSheet) {
            NewShelfSheet()
                .presentationDetents([.fraction(2/3)])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var addBookButton: some View {
        Button {
            isShowingLibraryChoser = true
        } label: {
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
                    .foregroundColor(.secondary)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    )
                    .aspectRatio(3/5, contentMode: .fill)
                    .frame(width: 90)
                
                VStack {
                    Text("")
                        .font(.system(.footnote, design: .serif))
                        .multilineTextAlignment(.center)
                    Text("")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
    
    private func bookCell(book: Book) -> some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                BookPhotoCell(for: book.safePhoto, width: 90)
                    .overlay(!isEditModeOn ? nil : ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.7))
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    })
                
                if book.isRead && !isEditModeOn {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.ruAccentColor)
                        .padding(5)
                }
                
                if book.isRead == false && book.isReading && !isEditModeOn {
                    CustomCircularProgressView(progress: CGFloat((book.safeEntries.filter({ $0.isVisible }).first?.safeCurrentPage ?? 0)) / CGFloat(book.safeNumberOfPages), width: 13)
                        .padding(5)
                }
            }
            
            VStack {
                Text(book.safeTitle)
                    .font(.system(.footnote, design: .serif))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .truncationMode(.middle)
                Text(book.safeAuthor)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .truncationMode(.middle)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if isEditModeOn {
                        isShowingConfirmation = true
                        bookToRemove = book
                    }
                }
        )
        
        .allowsHitTesting(isEditModeOn)
    }
    
    private func bookContextMenu(book: Book) -> some View {
        Group {
            Button {
                book.isReading.toggle()
                if book.isReading == true {
                    book.isRead = false
                }
                try? moc.save()
            } label: {
                Label("\(book.isReading ? "Stop Reading" : "Start Reading")", systemImage: book.isReading ? "book" : "book.closed")
            }
            
            if book.isReading {
                Button {
                    bookToUpdate = book
                } label: {
                    Label("Update Progress", systemImage: "pencil")
                }
            }
            
            Divider()
            
            Menu {
                Button {
                    isShowingNewShelfSheet = true
                } label: {
                    Label("Add New", systemImage: "plus")
                }
                
                Divider()
                
                ForEach(shelves) { shelf in
                    Button {
                        if book.safeShelves.contains(shelf) {
                            book.removeFromShelves(shelf)
                        } else {
                            book.addToShelves(shelf)
                        }
                        
                        try? moc.save()
                        
                    } label: {
                        Label(shelf.safeTitle, systemImage: "\(shelf.safeIcon)\(book.safeShelves.contains(shelf) ? ".fill" : "")")
                    }
                }
                
            } label: {
                Label("Shelves", systemImage: "books.vertical")
            }
            
            if let shelf {
                Button(role: .destructive) {
                    withAnimation {
                        book.removeFromShelves(shelf)
                        try? moc.save()
                    }
                } label: {
                    Label("Remove From Shelf", systemImage: "trash")
                }
            }
            
            if shelf == nil {
                Button(role: .destructive) {
                    withAnimation {
                        moc.delete(book)
                        try? moc.save()
                    }
                } label: {
                    Label("Remove Book", systemImage: "trash")
                }
            }
        }
    }
}
