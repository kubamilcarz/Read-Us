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
        SortDescriptor(\.dateAdded, order: .reverse)
    ], predicate: NSPredicate(format: "isReading == true")) var books: FetchedResults<Book>
    
    @FetchRequest<Entry>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var entries: FetchedResults<Entry>
    
    @FetchRequest<Shelf>(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var shelves: FetchedResults<Shelf>
    
    var filteredEntries: [Entry] {
        entries.filter { $0.safeDateAdded.midnight == Date().midnight && $0.isVisible }
    }
    
    var numberOfPagesReadToday: Int {
        var number = 0
        _ = filteredEntries.map { number += $0.safeNumerOfPagesRead }
        
        return number
    }
    
    @State private var updatingBook: Book?
    @State private var isShowingNewShelfSheet = false
    @State private var isShowingReadingHistorySheet = false
    @State private var isBookChooserOpen = false
        
    @AppStorage("dailyGoal") var dailyGoal = 20
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    todaysReading
                        .padding(.horizontal)
                    
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
                                        isBookChooserOpen = true
                                    }
                            }
                            
                            ForEach(books) { book in
                                NavigationLink(value: book) {
                                    bookCell(book: book)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                            Rectangle()
                                .fill(.background)
                                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -15)
                        
                        listsSection
                            .padding(.vertical, 15)
                            .padding(.horizontal)
                            .background(.ultraThinMaterial)
                    }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)

                            Rectangle()
                                .fill(.background)
                                .cornerRadius(24, corners: [.topLeft, .topRight])
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -15)
                        
                        ReadingGoalsSection()
                            .padding(.vertical, 10)
                            .padding(.bottom, 15)
                    }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                            Rectangle()
                                .fill(.background)
                                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -30)
                        
                        ReadThisYearSection(for: Date.now.year)
                            .padding(.vertical, 30)
                            .padding(.horizontal)
                            .background(.ultraThinMaterial)
                    }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                            
                            Rectangle()
                                .fill(.background)
                                .cornerRadius(24, corners: [.topLeft, .topRight])
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -15)
                        
                    }
                    
                }
                .padding(.bottom, 50)
            }
            .navigationTitle("Reading Now")
            
            .sheet(item: $updatingBook) { book in
                UpdateBookProgressSheet(book: book)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            
            .sheet(isPresented: $isShowingNewShelfSheet) {
                NewShelfSheet()
                    .presentationDetents([.fraction(2/3)])
                    .presentationDragIndicator(.visible)
            }
            
            .sheet(isPresented: $isShowingReadingHistorySheet) {
                TodaysReadingSheet()
                    .presentationDragIndicator(.visible)
            }
            
            .sheet(isPresented: $isBookChooserOpen) {
                BookChooserSheet(readingNow: true)
                    .presentationDragIndicator(.visible)
            }
            
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
                    .presentationDragIndicator(.visible)
            }
            
            .tint(.ruAccentColor)
        }
    }
}

extension ReadingNowView {
    private var listsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Shelves")
                    .font(.system(.title2, design: .serif))
                    .bold()
                
                Spacer()
            
                NavigationLink(destination: ShelvesView(isNested: true)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.ruAccentColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                if shelves.isEmpty {
                    Button {
                        isShowingNewShelfSheet = true
                    } label: {
                        ShelfRow()
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                } else {
                    ForEach(shelves.prefix(3)) { shelf in
                        NavigationLink(destination: ShelfDetailView(shelf: shelf)) {
                            listRow(shelf: shelf)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private func listRow(shelf: Shelf) -> some View {
        ShelfRow(shelf: shelf)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func bookRow(book: Book) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text(book.safeTitle)
                    .font(.system(.headline, design: .serif))
                Text(book.safeAuthor)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                
                Text(round((Double(mainVM.getCurrentPage(for: book))/Double(book.safeNumberOfPages)) * 100) / 100.0, format: .percent)
                    .font(.footnote)
                
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundStyle(.tertiary)
                
                Circle()
                    .trim(from: 0, to: CGFloat(mainVM.getCurrentPage(for: book)) / CGFloat(book.numberOfPages))
                    .stroke(lineWidth: 3)
                    .foregroundColor(Color.ruAccentColor)
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 44, height: 44)
            
            Menu {
                bookCellContextMenu(for: book)
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(
            ZStack {
                Image(uiImage: book.safePhoto)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 10)
                
                Rectangle().fill(.ultraThinMaterial)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func bookCell(book: Book) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(book.safeTitle)
                        .font(.system(.headline, design: .serif))
                    
                    Text(book.safeAuthor)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .foregroundStyle(.white)
                
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
                Image(uiImage: book.safePhoto)
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
                    mainVM.finish(moc: moc, book: book)
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
                        if book.safeShelves.contains(shelf) {
                            book.removeFromShelves(shelf)
                        } else {
                            book.addToShelves(shelf)
                        }
                        
                        try? moc.save()
                        
                    } label: {
                        Label(shelf.safeTitle, systemImage: "\(shelf.safeIcon)\(book.safeShelves.contains(shelf) ? ".fill" : "")")
                    }
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
    
    private var todaysReading: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                CustomCircularProgressView(progress: CGFloat(numberOfPagesReadToday) / CGFloat(dailyGoal), width: 13)
                
                Text("Today's Reading")
                    .foregroundColor(.ruAccentColor)
                    .font(.system(size: 12, weight: .semibold))
                
                Text("\(numberOfPagesReadToday)/\(dailyGoal) pages")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .onTapGesture {
                isShowingReadingHistorySheet = true
            }
            
            Divider()
        }
    }
}
