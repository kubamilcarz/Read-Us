//
//  CurrentlyReadingBookCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct CurrentlyReadingBookCell: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var moc
    
    var book: Book
    var shelves: FetchedResults<Shelf>
    @Binding var isShowingNewShelfSheet: Bool
    
    var progress: Double {
        round((Double(dataManager.getCurrentPage(for: book))/Double(book.number_of_pages)) * 100) / 100.0
    }
    
    @State private var updatingBook: Book?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(book.title_string)
                        .font(.system(.headline, design: .serif))
                    
                    Text(book.author_string)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                    
                    Text(progress, format: .percent)
                        .font(.footnote)
                }
                .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                CustomProgressView(value: CGFloat(dataManager.getCurrentPage(for: book)) / CGFloat(book.numberOfPages))
                
                Button {
                    updatingBook = book
                } label: {
                    Text("Update Progress")
                        .font(.system(size: 10))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                        .background(Color.ruAccentColor, in: Capsule())
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .aspectRatio(16/9, contentMode: .fill)
        .frame(maxWidth: 400, maxHeight: 160)
        .frame(minHeight: 160)
        .background(
            ZStack {
                Image(uiImage: book.cover_image)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 10)
                
                Rectangle().fill(.ultraThinMaterial)
                
                Rectangle().fill(.black.opacity(0.1))
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        .contextMenu {
            bookCellContextMenu(for: book)
        }
        
        .sheet(item: $updatingBook) { book in
            UpdateBookProgressSheet(book: book)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
    
    private func bookCellContextMenu(for book: Book) -> some View {
        Group {
            Button {
                updatingBook = book
            } label: {
                Label("Update", systemImage: "pencil")
            }
            
            Button {
                withAnimation {
                    dataManager.finish(moc: moc, book: book)
                }
            } label: {
                Label("Finish", systemImage: "flag")
            }
            
            Menu {
                Button {
                    isShowingNewShelfSheet = true
                } label: {
                    Label("Add New", systemImage: "plus")
                }
                
                Divider()
                
                ForEach(shelves) { shelf in
                    Button {
                        if book.shelvesArray.contains(shelf) {
                            book.removeFromShelves(shelf)
                        } else {
                            book.addToShelves(shelf)
                        }
                        
                        try? moc.save()
                        
                    } label: {
                        Label(shelf.title_string, systemImage: "\(shelf.icon_string)\(book.shelvesArray.contains(shelf) ? ".fill" : "")")
                    }
                }
                
            } label: {
                Label("Bookshelf", systemImage: "books.vertical")
            }
            
            Divider()
            
            Button(role: .destructive) {
                withAnimation {
                    dataManager.pauseCurrentReading(moc: moc, for: book)
                }
            } label: {
                Text("Stop Reading")
            }
        }
    }
}
