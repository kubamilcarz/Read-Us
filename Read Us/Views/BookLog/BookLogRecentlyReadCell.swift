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
        bookReadings.filter({ $0.dateFinished != nil })
    }
    
    var first5Readings: [BookReading] {
        Array(filteredReadings.prefix(5))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Recently Read")
                    .font(.system(.title3, design: .serif))
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    ReadingLogList(readings: filteredReadings)
                } label: {
                    Text("All")
                        .font(.subheadline)
                }
                .controlSize(.mini)
            }
            
            if first5Readings.isEmpty {
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
                BookLogList(readings: first5Readings)
            }
        }
    }
}
