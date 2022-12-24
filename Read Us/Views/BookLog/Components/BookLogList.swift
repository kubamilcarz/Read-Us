//
//  BookLogList.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/24/22.
//

import SwiftUI

struct BookLogList: View {
    
    var readings: [BookReading]
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Divider()
            }
            .padding(.vertical)
            .padding(.leading, 32.5)
            
            VStack {
                ForEach(readings) { reading in
                    if let book = reading.book {
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            BookReadingCell(book: book, finishDate: reading.date_finished, readingID: reading.id)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 7.5)
                    }
                }
            }
        }
    }
}
