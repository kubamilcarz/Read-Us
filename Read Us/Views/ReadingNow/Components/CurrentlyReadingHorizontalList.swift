//
//  CurrentlyReadingHorizontalList.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct CurrentlyReadingHorizontalList: View {
    
    var shelves: FetchedResults<Shelf>
    @Binding var isShowingNewShelfSheet: Bool
    
    @State private var isShowingBookChooser = false
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ], predicate: NSPredicate(format: "isReading == true")) var books: FetchedResults<Book>
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if books.isEmpty {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .aspectRatio(16/9, contentMode: .fill)
                        .frame(maxWidth: 400, maxHeight: 160)
                        .frame(minHeight: 160)
                        .overlay(
                            VStack(spacing: 10) {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                
                                Text("Start Reading")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.secondary)
                            }
                        )
                        .onTapGesture {
                            isShowingBookChooser = true
                        }
                }
                
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        CurrentlyReadingBookCell(book: book, shelves: shelves, isShowingNewShelfSheet: $isShowingNewShelfSheet)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $isShowingBookChooser) {
            BookChooserSheet(readingNow: true)
                .presentationDragIndicator(.visible)
        }
    }
}
