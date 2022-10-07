//
//  BookChooserSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/6/22.
//

import SwiftUI

struct BookChooserSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    var shelf: Shelf
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var books: FetchedResults<Book>
    
    init(for shelf: Shelf) {
        self.shelf = shelf
    }
    
    @State private var query = ""
    
    var filteredBooks: [Book] {
        if query.isEmpty {
            return books.compactMap { $0 }
        }
        
        return books.filter { $0.safeTitle.lowercased().contains(query.lowercased()) || $0.safeAuthor.lowercased().contains(query.lowercased()) }
    }
    
    var body: some View {
        NavigationView {
            List(filteredBooks) { book in
                row(book: book)
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Search Library"))
            
            .navigationTitle("Choose Books")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    private func row(book: Book) -> some View {
        HStack {
            Image(systemName: shelf.safeBooks.contains(book) ? "checkmark.circle" : "circle")
                .foregroundColor(shelf.safeBooks.contains(book) ? .accentColor : .secondary)
            
            VStack(alignment: .leading) {
                Text(book.safeTitle)
                    .font(.system(.subheadline, design: .serif))
                    .bold()
                Text(book.safeAuthor)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .onTapGesture {
            if shelf.safeBooks.contains(book) {
                shelf.removeFromBooks(book)
            } else {
                shelf.addToBooks(book)
            }
            
            try? moc.save()
        }
    }
}
