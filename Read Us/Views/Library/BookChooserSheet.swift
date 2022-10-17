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
    
    var shelf: Shelf?
    var readingNow: Bool?
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var books: FetchedResults<Book>
    
    init(for shelf: Shelf) {
        self.shelf = shelf
    }
    
    init(readingNow: Bool) {
        self.readingNow = readingNow
    }

    
    @State private var query = ""
    
    var filteredBooks: [Book] {
        var filBooks = books.compactMap { $0 }
        
        if let readingNow, readingNow {
            filBooks = books.filter { $0.isRead == false }
        }
        
        if query.isEmpty {
            return filBooks
        }
        
        return filBooks.filter { $0.safeTitle.lowercased().contains(query.lowercased()) || $0.safeAuthor.lowercased().contains(query.lowercased()) }
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
            Image(systemName: readingNow != nil ? (book.isReading ? "checkmark.circle.fill" : "circle") : shelf?.safeBooks.contains(book) ?? false ? "checkmark.circle.fill" : "circle")
                .foregroundColor(readingNow != nil ? (book.isReading ? .ruAccentColor : .secondary) :  shelf?.safeBooks.contains(book) ?? false ? .ruAccentColor : .secondary)
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
            if let shelf {
                if shelf.safeBooks.contains(book) {
                    shelf.removeFromBooks(book)
                } else {
                    shelf.addToBooks(book)
                }
                
                try? moc.save()
            }
            
            if let readingNow, readingNow {
                book.isReading.toggle()
                
                try? moc.save()
            }
        }
    }
}
