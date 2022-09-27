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
        self._rating = State(wrappedValue: book.safeRating)
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
        book.rating = Int16(newRating)
        
        try? moc.save()
        
        withAnimation {
            rating = newRating
        }
    }
}
