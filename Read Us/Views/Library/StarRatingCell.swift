//
//  StarRatingCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct StarRatingCell: View {
    @Environment(\.managedObjectContext) var moc
    
    var book: Book
    @State private var rating: Int
    
    init(for book: Book) {
        self.book = book
        
        let bookReadings = book.bookReadingsArray.sorted(by: { $0.date_finished < $1.date_finished })
        
        self._rating = State(wrappedValue: bookReadings.first?.rating_int ?? 0)
    }
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(1..<6) { star in
                Image(systemName: "star\(star <= rating ? ".fill" : "")")
                    .imageScale(.small)
                    .onTapGesture {
                        changeRating(to: star)
                    }
            }
        }
        .accessibilityElement()
        .accessibility(hint: Text("You rated this book with \(rating) stars"))
    }
    
    private func changeRating(to newRating: Int) {
        if book.bookReadingsArray.isEmpty {
            // if no readings, add one reading
            let newReading = BookReading(context: moc)
            newReading.id = UUID()
            newReading.rating = Int64(newRating)
            newReading.dateFinished = Date.now
            newReading.isReading = false
            newReading.countToStats = false
            
            book.addToBookReadings(newReading)
        } else {
            // get the latest, and change it
            book.bookReadingsArray.sorted(by: { $0.date_finished < $1.date_finished }).first?.rating = Int64(newRating)
        }
        
        try? moc.save()
        
        withAnimation {
            rating = newRating
        }
    }
}
