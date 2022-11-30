//
//  DeveloperReadingHistory.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/30/22.
//

import SwiftUI

struct DeveloperReadingHistory: View {
    @EnvironmentObject var dataManager: DataManager
    
    @FetchRequest<BookReading>(sortDescriptors: [
        SortDescriptor(\.dateStarted, order: .reverse)
    ]) var readings: FetchedResults<BookReading>
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(readings) { reading in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(reading.book?.title_string ?? "Unknown")
                                .font(.headline)
                            Text("\(reading.book?.author_string ?? "Unknown") (cp: \(dataManager.getCurrentPage(for: reading.book ?? Book())))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(reading.date_started.formatted(date: .abbreviated, time: .standard))
                            Text(reading.date_finished.formatted(date: .abbreviated, time: .standard))
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .strikethrough(reading.dateFinished != nil)
                    .opacity(reading.dateFinished != nil ? 0.6 : 1)
                }
            }
            .padding(.horizontal)
        }.frame(maxHeight: 200)
    }
}

struct DeveloperReadingHistory_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperReadingHistory()
    }
}
