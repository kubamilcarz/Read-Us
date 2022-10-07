//
//  ShelfDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/4/22.
//

import SwiftUI

struct ShelfDetailView: View {
    @Environment(\.presentationMode) var presentionMode
    @Environment(\.managedObjectContext) var moc
    
    var shelf: Shelf
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var books: FetchedResults<Book>
    
    @FetchRequest<Shelf>(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var shelves: FetchedResults<Shelf>
    
    var filteredBooks: [Book] {
        books.filter { $0.safeShelves.contains(shelf) }
    }
    
    @State private var isShowingNewShelfSheet = false
    @State private var isEditModeOn = false
    @State private var isShowingLibraryChoser = false
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var bookToUpdate: Book?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 25) {
                    Image(systemName: shelf.safeIcon)
                        .font(.system(size: 60).bold())
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .center, spacing: 5) {
                        if isEditModeOn {
                            TextField(shelf.safeTitle, text: $title)
                                .font(.system(.title, design: .serif))
                                .frame(maxWidth: 240)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField(shelf.safeSubtitle, text: $subtitle, axis: .vertical)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: 170)
                                .lineLimit(1...5)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            Text(shelf.safeTitle)
                                .font(.system(.title, design: .serif))
                                .multilineTextAlignment(.center)
                            
                            if shelf.safeSubtitle.isEmpty == false {
                                Text(shelf.safeSubtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: 170)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding(30)
                .padding(.bottom, isEditModeOn ? -20 : 0)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 15)], alignment: .leading) {
                    ForEach(filteredBooks, id: \.id) { book in
                        bookCell(book: book)
                    }
                    
                    if !isEditModeOn { addBookButton }
                }
                
                if filteredBooks.count >= 5 {
                    VStack(spacing: 5) {
                        Text("Total")
                            .font(.caption)
                            .textCase(.uppercase)
                            .foregroundColor(.secondary)
                        Text("\(filteredBooks.count)")
                            .font(.system(size: 64, design: .serif))
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 75)
        }
        .navigationTitle(shelf.safeTitle)
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingNewShelfSheet) {
            NewShelfSheet()
                .presentationDetents([.fraction(2/3)])
        }
        
        .sheet(isPresented: $isShowingLibraryChoser) {
            BookChooserSheet(for: shelf)
        }
        
        .sheet(item: $bookToUpdate, content: { _ in
            if let bookToUpdate {
                UpdateBookProgressSheet(book: bookToUpdate)
                    .presentationDetents([.height(220)])
            }
        })
        
        .toolbar {
            Button(isEditModeOn ? "Done" : "Edit") {
                withAnimation {
                    isEditModeOn.toggle()
                }
            }
        }
        
        .onAppear {
            title = shelf.safeTitle
            subtitle = shelf.safeSubtitle
        }
        
        .onChange(of: isEditModeOn) { _ in
            shelf.title = title
            shelf.subtitle = subtitle
            
            if moc.hasChanges {
                try? moc.save()
            }
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
                    .overlay(!isEditModeOn ? nil :
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.7))
                            
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    )
                
                if book.isRead {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .padding(5)
                }
                
                if book.isRead == false && book.isReading {
                    CustomCircularProgressView(progress: CGFloat((book.safeEntries.filter({ $0.isVisible }).first?.safeCurrentPage ?? 0)) / CGFloat(book.safeNumberOfPages), width: 13)
                        .padding(5)
                }
            }
            
            VStack {
                Text(book.safeTitle)
                    .font(.system(.footnote, design: .serif))
                    .multilineTextAlignment(.center)
                Text(book.safeAuthor)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .overlay(
            !isEditModeOn ? NavigationLink(destination: BookDetailView(book: book)) { RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.01)) } : nil
        )
        .buttonStyle(.plain)
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if isEditModeOn {
                        withAnimation {
                            book.removeFromShelves(shelf)
                            try? moc.save()
                        }
                    }
                }
        )
        
        .contextMenu {
            contextMenu(book: book)
        }
    }
    
    private func contextMenu(book: Book) -> some View {
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
            
            Button(role: .destructive) {
                withAnimation {
                    book.removeFromShelves(shelf)
                    try? moc.save()
                }
            } label: {
                Label("Remove From Shelf", systemImage: "trash")
            }
        }
    }
}
