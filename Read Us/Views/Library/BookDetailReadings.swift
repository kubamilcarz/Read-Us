//
//  BookDetailReadings.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/30/22.
//

import SwiftUI

struct BookDetailReadings: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataManager: DataManager
    
    var book: Book
    
    var body: some View {
        VStack {
            HStack {
                Text("Readings")
                    .font(.system(.headline, design: .serif))
                
                Spacer()
                
                HStack {
                    if dataManager.getCurrentBookReading(for: book) == nil {
                        Button("Read Again") {
                            dataManager.startNewRead(moc: moc, for: book)
                        }
                    }
                    
                    if book.bookReadingsArray.filter({ $0.dateFinished == nil }).isEmpty {
                        Button("Add") {
                            #warning("Show Sheet with Option to back log your past readings")
                        }
                        .font(.system(size: 10))
                        .controlSize(.mini)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 3) {
                ForEach(book.bookReadingsArray.sorted(by: { $0.date_started > $1.date_started })) { reading in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: reading.dateFinished == nil ? "circle" : "checkmark.circle.fill")
                            .foregroundColor(reading.dateFinished == nil ? .secondary : .ruAccentColor)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                if reading.dateFinished == nil {
                                    Text("\(reading.date_started.formatted(date: .abbreviated, time: .omitted)) - Now")
                                        .font(.system(.caption2, design: .serif))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                } else {
                                    Text("\(reading.date_started.formatted(date: .abbreviated, time: .omitted)) - \(reading.date_finished.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.system(.caption2, design: .serif))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    StarRatingCell(for: .constant(reading.rating_int))
                                        .allowsHitTesting(false)
                                }
                            }
                            
                            if reading.dateFinished != nil && reading.review_string.count > 0 {
                                Text(reading.review_string)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .font(.system(size: 12))
        .buttonStyle(.bordered)
        .controlSize(.mini)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .clipped()
    }
}
