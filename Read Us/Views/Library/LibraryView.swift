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
    
    @State private var isEditModeOn = false
    @State private var query = ""
    
    var filteredBooks: [Book] {
        if query.isEmpty {
            return books.compactMap { $0 }
        }
        
        return books.filter { $0.safeTitle.lowercased().contains(query.lowercased()) || $0.safeAuthor.lowercased().contains(query.lowercased()) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                BookGrid(
                    books: filteredBooks,
                    isEditModeOn: $isEditModeOn,
                    isShowingLibraryChoser: .constant(false),
                    isShelf: false
                )
                    .padding(.horizontal)
                    .padding(.bottom, 75)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(isEditModeOn ? "Done" : "Edit") {
                        withAnimation {
                            isEditModeOn.toggle()
                        }
                    }
                    .tint(.ruAccentColor)
                    navBarAddButton
                        .tint(.ruAccentColor)
                }
            }
            .sheet(isPresented: $isShowingNewBookSheet) {
                NewBookSheet()
                    .presentationDragIndicator(.visible)
//                    .presentationDetents([.fraction(2/3)])
            }
            
            .searchable(text: $query.animation(.easeInOut), placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Search Library"))
            
            .tint(.ruAccentColor)
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
                .symbolRenderingMode(.hierarchical)
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
