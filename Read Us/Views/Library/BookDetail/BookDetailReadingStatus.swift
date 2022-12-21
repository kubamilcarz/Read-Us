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
        if ((book.bookReadingsArray.isEmpty && !book.isReading) || !(dataManager.getLatestBookReading(for: book)?.isReading ?? false)) {
            VStack {
                if book.bookReadingsArray.isEmpty && !book.isReading {
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
                }
                
                if dataManager.getLatestBookReading(for: book)?.isReading == false {
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
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .clipped()
        }
    }
}
