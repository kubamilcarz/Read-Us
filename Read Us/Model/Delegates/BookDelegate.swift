//
//  BookDelegate.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/21/22.
//

import Foundation

extension DataManager {
    func getLatestBookReading(for book: Book) -> BookReading? {
        book.bookReadingsArray.sorted(by: { $0.date_finished > $1.date_finished }).first
    }
    
    func getCurrentBookReading(for book: Book) -> BookReading? {
        book.bookReadingsArray.first(where: { $0.isReading && $0.dateFinished == nil && !$0.countToStats })
    }
    
    func getCurrentPage(for book: Book) -> Int {
        book.bookUpdatesArray.sorted(by: { $0.date_added > $1.date_added }).first?.current_page ?? 0
    }
    
    func getCurrentProgress(for book: Book, inPercentage: Bool) -> Double {
        round((Double(getCurrentPage(for: book))/Double(book.number_of_pages)) * 100) / 100.0
    }
}
