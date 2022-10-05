//
//  ShelfDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/4/22.
//

import SwiftUI

struct ShelfDetailView: View {
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
    
    var body: some View {
        List {
            HStack(spacing: 25) {
                Image(systemName: shelf.safeIcon)
                    .font(.largeTitle.bold())
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(shelf.safeTitle)
                        .font(.system(.title, design: .serif))
                    if shelf.safeSubtitle.isEmpty == false {
                        Text(shelf.safeSubtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .withoutListInset()
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            
            Section {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 15)], alignment: .leading) {
                    ForEach(filteredBooks, id: \.id) { book in
                        bookCell(book: book)
                    }
                }
            }
            .withoutListInset()
            .listRowBackground(
                RoundedRectangle(cornerRadius: 12).fill(.clear)
            )
            
            if filteredBooks.count >= 6 {
                VStack {
                    Text("Total")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)
                    Text("\(filteredBooks.count)")
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .withoutListInset()
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 12).fill(.clear)
                )
            }
        }
        .navigationTitle(shelf.safeTitle)
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingNewShelfSheet) {
            NewShelfSheet()
                .presentationDetents([.fraction(2/3)])
        }
        
        .toolbar {
            Button(isEditModeOn ? "Done" : "Edit") {
                withAnimation {
                    isEditModeOn.toggle()
                }
            }
        }
    }
    
    private func bookCell(book: Book) -> some View {
        Menu {
            NavigationLink {
                BookDetailView(book: book)
            } label: {
                Label("Learn more", systemImage: "chevron.right")
            }
            
            Divider()

            Button {
                book.isReading.toggle()
                if book.isReading == true {
                    book.isRead = false
                }
                try? moc.save()
            } label: {
                Label("\(book.isReading ? "Stop Reading" : "Start Reading")", systemImage: book.isReading ? "book" : "book.closed")
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
                Label("Remove from shelf", systemImage: "trash")
            }
            
        } label: {
            VStack {
                BookPhotoCell(for: book.safePhoto, width: 90)
                    .overlay(!isEditModeOn ? nil :
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.7))
                            
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    )
                
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
        } primaryAction: {
            if isEditModeOn {
                withAnimation {
                    book.removeFromShelves(shelf)
                    try? moc.save()
                }
            }
        }
        .buttonStyle(.plain)
    }
}
