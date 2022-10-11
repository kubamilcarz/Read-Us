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
            .searchable(text: $query.animation(.easeInOut), placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Search Library"))
            
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
        HStack(spacing: 15) {
            Image(systemName: shelf.safeBooks.contains(book) ? "checkmark.circle.fill" : "circle")
                .foregroundColor(shelf.safeBooks.contains(book) ? .accentColor : .secondary)
                .symbolRenderingMode(.hierarchical)
            
            VStack(alignment: .leading) {
                Text(book.safeTitle)
                    .font(.system(.subheadline, design: .serif))
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(book.safeAuthor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
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
