//
//  LibraryView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest<Book>(sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var isShowingNewBookSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        BookDetailView(book: book)
                    } label: {
                        bookCell(book: book)
                    }
                }
                .onDelete(perform: removeBook)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton().tint(.secondary)
                    navBarAddButton.tint(.secondary)
                }
                
            }
            .sheet(isPresented: $isShowingNewBookSheet) {
                NewBookSheet()
//                    .presentationDetents([.fraction(2/3)])
            }
        }
    }
    
    private func removeBook(at offsets: IndexSet) {
        for index in offsets {
            let book = books[index]
            moc.delete(book)
            try? moc.save()
        }
    }
    
    private var navBarAddButton: some View {
        Button {
            isShowingNewBookSheet = true
        } label: {
            Label("Add Book", systemImage: "plus.circle.fill")
        }
    }
    
    private func bookCell(book: Book) -> some View {
        HStack(alignment: .top) {
            BookPhotoCell(for: book.safePhoto, width: 70)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(book.safeTitle)
                    .font(.system(.headline, design: .serif))
                Text(book.safeAuthor)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
