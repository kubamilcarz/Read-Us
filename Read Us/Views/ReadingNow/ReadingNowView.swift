//
//  ReadingNowView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

struct ReadingNowView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse),
        SortDescriptor(\.title, order: .forward)
    ], predicate: NSPredicate(format: "isReading == true")) var books: FetchedResults<Book>
    
    @State private var updatingBook: Book?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    readingNowSection
                }
                .padding(.horizontal)
            }
            .navigationTitle("Reading Now")
            
            .sheet(item: $updatingBook) { book in
                UpdateBookProgressSheet(book: book)
                    .presentationDetents([.height(220)])
            }
        }
    }
}

extension ReadingNowView {
    private var readingNowSection: some View {
        VStack {
//            HStack {
//                Text("Reading Now")
//                    .font(.system(.headline, design: .serif))
//
//                Spacer()
//
//                Button { } label: {
//                    Text("All")
//                        .font(.caption)
//                }
//            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(books) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            readingNowBookCell(book: book)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private func readingNowBookCell(book: Book) -> some View {
        ZStack(alignment: .top) {
            Image(uiImage: book.safePhoto)
                .resizable()
                .scaledToFill()
                .blur(radius: 15)
                .frame(maxWidth: 400, maxHeight: 160)
            
            Rectangle()
                .fill(.ultraThinMaterial).opacity(0.8)
                .frame(maxWidth: 400, maxHeight: 160)
            
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(book.safeTitle)
                                .font(.system(.headline, design: .serif))
                            
                            Text(book.safeAuthor)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                            
                            Text(round((Double(mainVM.getCurrentPage(for: book))/Double(book.safeNumberOfPages)) * 100) / 100.0, format: .percent)
                                .font(.footnote)
                        }
                        .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        CustomProgressView(value: CGFloat(mainVM.getCurrentPage(for: book)) / CGFloat(book.numberOfPages))
                        
                        Button {
                            updatingBook = book
                        } label: {
                            Text("Update Progress")
                                .font(.system(size: 10))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 7)
                                .background(Color.accentColor.gradient.opacity(0.7), in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .frame(maxWidth: 400, maxHeight: 160)
            }
        }
        .aspectRatio(16/9, contentMode: .fill)
        .frame(maxWidth: 400, maxHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        .contextMenu {
            Button {
                updatingBook = book
            } label: {
                Label("Update", systemImage: "pencil")
            }
            
            Button {
                withAnimation {
                    mainVM.finish(moc: moc, book: book)
                }
            } label: {
                Label("Finish", systemImage: "flag")
            }
            
            Menu {
                Button {
                    
                } label: {
                    Label("Add New", systemImage: "plus")
                }
            } label: {
                Label("Bookshelf", systemImage: "books.vertical")
            }
            
            Divider()
            
            Button(role: .destructive) {
                withAnimation {
                    book.isReading = false
                    try? moc.save()
                }
            } label: {
                Text("Stop Reading")
            }
        }
    }
}
