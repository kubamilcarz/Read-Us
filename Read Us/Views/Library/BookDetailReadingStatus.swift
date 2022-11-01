//
//  BookDetailReadingStatus.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

struct BookDetailReadingStatus: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var mainVM: MainViewModel
    
    var book: Book
    
    // determine overlays
    var stoppedReading: Bool { book.isReading == false && book.isRead == false && book.bookUpdatesArray.isEmpty == false }
    var isNewBook: Bool { book.isReading == false && book.isRead == false && book.bookUpdatesArray.isEmpty }
    
    var latestReadDate: BookReading? {
        mainVM.getLatestBookReading(for: book)
    }
    
    var readingTime: Double {
        Double(Double(latestReadDate?.date_finished.timeIntervalSince(latestReadDate?.date_started ?? Date.now) ?? 0) / 86_400)
    }
    
    private func getReadingTime(for reading: BookReading) -> Int {
        Int(reading.date_finished.timeIntervalSince(reading.date_started) / 86_400)
    }
    
    var body: some View {
        VStack {
            if isNewBook {
                VStack {
                    Text("Start reading this book")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                    HStack {
                        Button("Read Later") {
                            
                        }
                        .font(.system(size: 12))
                        
                        Button("Start") {
                            book.isReading = true
                            try? moc.save()
                        }
                        .font(.system(size: 12))
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                }
            } else if stoppedReading {
                VStack {
                    Text("You stopped reading this book")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                    HStack {
                        Button("Cancel", role: .destructive) {
                            mainVM.resetProgress(moc: moc, for: book)
                        }
                        .font(.system(size: 12))
                        
                        Button("Resume") {
                            book.isReading = true
                            try? moc.save()
                        }
                        .font(.system(size: 12))
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                }
            } else if book.isRead {
                VStack {
                    if book.bookReadingsArray.count == 1 {
                        VStack {
                            Text("You read this book on \((latestReadDate?.date_finished ?? Date.now).formatted(date: .abbreviated, time: .omitted))")
                            Text("Read in \(Int(readingTime)) days")
                        }
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                    } else if book.bookReadingsArray.count > 1 {
                        VStack {
                            ForEach(book.bookReadingsArray.sorted(by: { $0.date_finished > $1.date_finished })) { reading in
                                HStack {
                                    Text("You read this book on \(reading.date_finished.formatted(date: .abbreviated, time: .shortened))")
                                    
                                    Spacer()
                                    
                                    Text("it took you \(getReadingTime(for: reading))")
                                }
                            }
                        }
                    }
                    
                    
                    Button("Read Again") {
                        mainVM.startNewRead(moc: moc, for: book)
                    }
                }
                .font(.system(size: 12))
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }
            
        }
        .aspectRatio(3/2, contentMode: .fill)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 160)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .clipped()
    }
}
