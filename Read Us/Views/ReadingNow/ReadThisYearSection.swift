//
//  ReadThisYearSection.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/11/22.
//

import SwiftUI

struct ReadThisYearSection: View {
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.finishedReadingOn, order: .reverse),
        SortDescriptor(\.title)
    ], predicate: NSPredicate(format: "isRead == true")) var books: FetchedResults<Book>
    
    var year: Int
    
    var filteredBooks: [Book] {
        books.filter { $0.safeFinishedReadingOn.year == year }
    }
    
    init(for year: Int) {
        self.year = year
        
        _books = FetchRequest<Book>(sortDescriptors: [
            SortDescriptor(\.finishedReadingOn, order: .reverse),
            SortDescriptor(\.title)
        ], predicate: NSPredicate(format: "isRead == true"))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text("\(year) So Far")
                    .font(.system(.title2, design: .serif))
                Text("You read **\(filteredBooks.count)** books")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 210)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50), spacing: 10)], alignment: .leading) {
                ForEach(filteredBooks) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        bookCell(book: book)
                    }
                    .frame(minWidth: 50)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func bookCell(book: Book) -> some View {
        BookPhotoCell(for: book.safePhoto, minWidth: 50)
    }
}
