//
//  BookLogList.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/23/22.
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
                        BookReadingCell(book: book, finishDate: reading.date_finished)
                            .padding(.vertical, 7.5)
                    }
                }
            }
        }
    }
}
