//
//  ReadingLogList.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct ReadingLogList: View {
    
    var readings: [BookReading]
        
    var body: some View {
        ScrollView {
            VStack {
                if readings.isEmpty {
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
                    ForEach(readings) { reading in
                        if let book = reading.book {
                            BookReadingCell(book: book, finishDate: reading.date_finished)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Reading Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}
