//
//  ExploreView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchQuery = ""
    
    @State private var fetchedBooks = [CachedBook]()
    
    var body: some View {
        NavigationStack {
            List(fetchedBooks) { book in
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author.dropLast().dropLast())
                        .foregroundStyle(.secondary)
                    Text(book.isbn10)
                        .font(.caption2)
                }
            }
            .navigationTitle("Explore")
        }
    }
}
