//
//  BookDetailReadingStatus.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

struct BookDetailReadingStatus: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataManager: DataManager
    
    var book: Book
    
    // determine overlays
    var stoppedReading: Bool { book.isReading == false && book.isRead == false && book.bookUpdatesArray.isEmpty == false }
    var isNewBook: Bool { book.isReading == false && book.isRead == false && book.bookUpdatesArray.isEmpty }
    
    var latestReadDate: BookReading? {
        dataManager.getLatestBookReading(for: book)
    }
    
    var readingTime: Double {
        Double(Double(latestReadDate?.date_finished.timeIntervalSince(latestReadDate?.date_started ?? Date.now) ?? 0) / 86_400)
    }
    
    private func getReadingTime(for reading: BookReading) -> Int {
        Int(reading.date_finished.timeIntervalSince(reading.date_started) / 86_400)
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Start reading this book")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                HStack {
                    Button("Read Later") {
                        
                    }
                    .font(.system(size: 12))
                    
                    Button("Start") {
                        dataManager.startNewRead(moc: moc, for: book)
                    }
                    .font(.system(size: 12))
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }
            
            VStack {
                Text("You stopped reading this book")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                HStack {
                    Button("Cancel", role: .destructive) {
                        dataManager.resetProgress(moc: moc, for: book)
                    }
                    .font(.system(size: 12))
                    
                    Button("Resume") {
                        dataManager.unpauseCurrentReading(moc: moc, for: book)
                    }
                    .font(.system(size: 12))
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }
            
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
                
                VStack(alignment: .leading) {
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
        }
//        .aspectRatio(3/2, contentMode: .fill)
        .padding()
//        .frame(maxWidth: .infinity, maxHeight: 160)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .clipped()
    }
}
