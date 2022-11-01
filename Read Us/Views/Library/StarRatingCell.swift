//
//  StarRatingCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct StarRatingCell: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.managedObjectContext) var moc
    
    var book: Book?
    @State private var rating: Int
    @Binding var bindedRating: Int
    
    init(for book: Book) {
        self.book = book
        self._bindedRating = Binding(projectedValue: .constant(0))
        
        let bookReadings = book.bookReadingsArray.sorted(by: { $0.date_finished > $1.date_finished })
        
        self._rating = State(wrappedValue: bookReadings.first?.rating_int ?? 0)
    }
    
    init(for rating: Binding<Int>) {
        self._bindedRating = Binding(projectedValue: rating)
        self._rating = State(wrappedValue: 0)
    }
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(1..<6) { star in
                Image(systemName: "star\(star <= rating ? ".fill" : "")")
                    .imageScale(.small)
                    .onTapGesture {
                        if star == rating {
                            changeRating(to: 0)
                        } else {
                            changeRating(to: star)
                        }
                    }
            }
        }
        .accessibilityElement()
        .accessibility(hint: Text("You rated this book with \(rating) stars"))
    }
    
    private func changeRating(to newRating: Int) {
        if let book {
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
                mainVM.getLatestBookReading(for: book)?.rating = Int64(newRating)
            }
        } else {
            // no book chosen
            bindedRating = newRating
        }
        
        try? moc.save()
        
        withAnimation {
            rating = newRating
        }
    }
}
