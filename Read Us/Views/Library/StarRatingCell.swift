//
//  StarRatingCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct StarRatingCell: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var moc
    
    var book: Book?
    @State private var rating: Int
    @Binding var bindedRating: Int
    private var isResetButtonVisible = false
    
    init(for book: Book, withResetButton: Bool = false) {
        self.book = book
        self._bindedRating = Binding(projectedValue: .constant(0))
        
        let bookReadings = book.bookReadingsArray.sorted(by: { $0.date_finished > $1.date_finished })
        
        self._rating = State(wrappedValue: bookReadings.first?.rating_int ?? 0)
        self.isResetButtonVisible = withResetButton
    }
    
    init(for rating: Binding<Int>) {
        self._bindedRating = Binding(projectedValue: rating)
        self._rating = State(wrappedValue: 0)
    }
        
    var body: some View {
        HStack {
            HStack(spacing: 3) {
                ForEach(1..<6) { star in
                    Image(systemName: "star\(star <= rating ? ".fill" : "")")
                        .imageScale(.small)
                        .transition(.scale)
                        .onTapGesture {
                            if star == rating {
                                changeRating(to: 0)
                            } else {
                                changeRating(to: star)
                            }
                        }
                }
            }
            if isResetButtonVisible && rating != 0 {
                Button(action: { changeRating(to: 0) }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.ruAccentColor)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
                .transition(.slide)
            }
        }
        .accessibilityElement()
        .accessibility(hint: Text("You rated this book with \(rating) stars"))
        .onAppear {
            if book == nil {
                rating = bindedRating
            }
        }
    }
    
    private func changeRating(to newRating: Int) {
        if let book {
            if book.bookReadingsArray.isEmpty {
                // if no readings, add one reading
                let newReading = BookReading(context: moc)
                newReading.id = UUID()
                newReading.rating = Int64(newRating)
                newReading.dateStarted = Date.now
                newReading.dateFinished = Date.now
                newReading.isReading = false
                newReading.countToStats = false
                
                book.addToBookReadings(newReading)
                
                try? moc.save()
            } else {
                // get the latest, and change it
                dataManager.getLatestBookReading(for: book)?.rating = Int64(newRating)
                
                try? moc.save()
            }
        } else {
            // no book chosen
            bindedRating = newRating
        }
        
        withAnimation {
            rating = newRating
        }
        
        try? moc.save()
    }
}
