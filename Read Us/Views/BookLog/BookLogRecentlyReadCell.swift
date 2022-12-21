//
//  BookLogRecentlyReadCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct BookLogRecentlyReadCell: View {
    @FetchRequest<BookReading>(sortDescriptors: [SortDescriptor(\.dateFinished, order: .reverse)]) var bookReadings: FetchedResults<BookReading>
    
    var filteredReadings: [BookReading] {
        Array(bookReadings.filter({ $0.dateFinished != nil }).prefix(5))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Recently Read")
                    .font(.system(.title3, design: .serif))
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    
                } label: {
                    Text("All")
                        .font(.subheadline)
                }
                .controlSize(.mini)
            }
            
            if filteredReadings.isEmpty {
                HStack {
                    VStack(spacing: 15) {
                        Image(systemName: "tray.fill")
                            .font(.title)
                        
                        Text("No read books")
                            .font(.body)
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 50)
            } else {
                ForEach(filteredReadings) { reading in
                    if let book = reading.book {
                        bookCell(book: book, finishDate: reading.date_finished)
                    }
                }
            }
        }
    }
    
    private func bookCell(book: Book, finishDate: Date) -> some View {
        HStack(alignment: .top, spacing: 15) {
            BookPhotoCell(for: book.cover, width: 65)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(book.title_string)
                        .font(.system(.subheadline, design: .serif))
                        .bold()
                    Text(book.author_string)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack {
                    Text("Finished on \(finishDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.vertical, 10)
        }
    }
}

struct BookLogRecentlyReadCell_Previews: PreviewProvider {
    static var previews: some View {
        BookLogRecentlyReadCell()
    }
}
