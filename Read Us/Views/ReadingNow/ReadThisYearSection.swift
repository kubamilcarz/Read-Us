//
//  ReadThisYearSection.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/11/22.
//

import FrameUp
import SwiftUI

struct ReadThisYearSection: View {
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.title)
    ], predicate: NSPredicate(format: "isRead == true")) var books: FetchedResults<Book>
    
    @State private var year: Int
    
    var filteredBooks: [Book] {
        books.filter { $0.bookReadingsArray.sorted(by: { $0.date_finished < $1.date_finished }).first?.date_finished.year == year }
    }
    
    init(for year: Int) {
        self._year = State(wrappedValue: year)
        
        _books = FetchRequest<Book>(sortDescriptors: [
            SortDescriptor(\.title)
        ], predicate: NSPredicate(format: "isRead == true"))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                if year-1 >= 2000 {
                    arrow(icon: "chevron.left") {
                        year -= 1
                    }
                } else {
                    Circle().fill(.clear).frame(width: 44, height: 44)
                }
                
                Spacer()
                
                sectionTitle
                
                Spacer()
                
                if year+1 <= Date.now.year {
                    arrow(icon: "chevron.right") {
                        year += 1
                    }
                } else {
                    Circle().fill(.clear).frame(width: 44, height: 44)
                }
            }
            
            if filteredBooks.isEmpty {
                Text("You haven't read any books")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 50)
            } else {
                WidthReader { width in
                    HFlow(alignment: .center, maxWidth: width, horizontalSpacing: 10, verticalSpacing: 10) {
                        ForEach(filteredBooks) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                bookCell(book: book)
                            }
                            .frame(minWidth: 50, maxWidth: 50)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func arrow(icon: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.tertiary)
                .frame(width: 44, height: 44)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
    
    private func bookCell(book: Book) -> some View {
        BookPhotoCell(for: book.cover, minWidth: 50)
    }
    
    private var sectionTitle: some View {
        VStack(spacing: 5) {
            Text("\(String(year)) So Far")
                .font(.system(.title2, design: .serif))
            Text("You read **\(filteredBooks.count)** books")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 210)
        }
    }
}
