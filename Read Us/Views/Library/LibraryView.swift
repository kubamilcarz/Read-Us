//
//  LibraryView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import CodeScanner
import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var moc
    @FetchRequest<Book>(sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var isShowingNewBookSheet = false
    @State private var isShowingLibraryChoser = false
    
    @State private var isShowingISBNCodeScanner = false
    
    @State private var isEditModeOn = false
    @State private var query = ""
    
    var filteredBooks: [Book] {
        if query.isEmpty {
            return books.compactMap { $0 }
        }
        
        return books.filter { $0.title_string.lowercased().contains(query.lowercased()) || $0.author_string.lowercased().contains(query.lowercased()) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if books.isEmpty {
                    GeometryReader { geo in
                        VStack(spacing: 15) {
                            Image(systemName: "tray.fill")
                                .font(.largeTitle)
                                .padding(.top, 100)
                            
                            Text("No Books")
                                .font(.title)
                        }
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    BookGrid(
                        books: filteredBooks,
                        isEditModeOn: $isEditModeOn,
                        isShowingLibraryChoser: $isShowingLibraryChoser
                    )
                    .padding(.horizontal)
                    .padding(.bottom, filteredBooks.count >= 9 ? 125 : 0)
                    
                    if filteredBooks.count >= 9 {
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
                        .padding(.bottom, 75)
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !books.isEmpty {
                        Button(isEditModeOn ? "Done" : "Edit") {
                            withAnimation {
                                isEditModeOn.toggle()
                            }
                        }
                        .tint(.ruAccentColor)
                    }
                    navBarAddButton
                        .tint(.ruAccentColor)
                }
            }
            .sheet(isPresented: $isShowingNewBookSheet) {
                NewBookSheet()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            
            .sheet(isPresented: $isShowingISBNCodeScanner) {
                ScanBookSheet()
            }
            
            .searchable(text: $query.animation(.easeInOut), placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Search Library"))

        }
        .tint(.ruAccentColor)
    }
    
    private func removeBook(at offsets: IndexSet) {
        for index in offsets {
            let book = books[index]
            moc.delete(book)
            try? moc.save()
        }
    }
    
    private var navBarAddButton: some View {
        Menu {
            Button {
                isShowingNewBookSheet = true
            } label: {
                Label("Manually", systemImage: "pencil")
            }
            
            Button {
                isShowingISBNCodeScanner = true
            } label: {
                Label("Scan Code", systemImage: "barcode.viewfinder")
            }
        } label: {
            Button {
                isShowingNewBookSheet = true
            } label: {
                Label("Add Book", systemImage: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
        }
    }
    
    private func bookCell(book: Book) -> some View {
        HStack(alignment: .top) {
            BookPhotoCell(for: book.cover, width: 70)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(book.title_string)
                    .font(.system(.headline, design: .serif))
                Text(book.author_string)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
