//
//  ShelfDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/4/22.
//

import SwiftUI

struct ShelfDetailView: View {
    @Environment(\.presentationMode) var presentionMode
    @Environment(\.managedObjectContext) var moc
    
    var shelf: Shelf
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var books: FetchedResults<Book>
    
    
    var filteredBooks: [Book] {
        books.filter { $0.safeShelves.contains(shelf) }
    }
    
    @State private var isEditModeOn = false
    @State private var isShowingLibraryChoser = false
    
    @State private var title = ""
    @State private var subtitle = ""
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 25) {
                    Image(systemName: shelf.safeIcon)
                        .font(.system(size: 60).bold())
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .center, spacing: 5) {
                        if isEditModeOn {
                            TextField(shelf.safeTitle, text: $title)
                                .font(.system(.title, design: .serif))
                                .frame(maxWidth: 240)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField(shelf.safeSubtitle, text: $subtitle, axis: .vertical)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: 170)
                                .lineLimit(1...5)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            Text(shelf.safeTitle)
                                .font(.system(.title, design: .serif))
                                .multilineTextAlignment(.center)
                            
                            if shelf.safeSubtitle.isEmpty == false {
                                Text(shelf.safeSubtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: 170)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding(30)
                .padding(.bottom, isEditModeOn ? -20 : 0)
                
                BookGrid(books: filteredBooks, isEditModeOn: $isEditModeOn, isShowingLibraryChoser: $isShowingLibraryChoser, isShelf: true, shelf: shelf)
                    .padding(.bottom, filteredBooks.count < 5 ? 75 : 0)
                
                if filteredBooks.count >= 5 {
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
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 75)
        }
        .navigationTitle(shelf.safeTitle)
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingLibraryChoser) {
            BookChooserSheet(for: shelf)
        }
        
        .toolbar {
            Button(isEditModeOn ? "Done" : "Edit") {
                withAnimation {
                    isEditModeOn.toggle()
                }
            }
        }
        
        .onAppear {
            title = shelf.safeTitle
            subtitle = shelf.safeSubtitle
        }
        
        .onChange(of: isEditModeOn) { _ in
            shelf.title = title
            shelf.subtitle = subtitle
            
            if moc.hasChanges {
                try? moc.save()
            }
        }
    }
}
