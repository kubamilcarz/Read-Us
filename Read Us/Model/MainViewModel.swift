//
//  MainViewModel.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import CoreData
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var tabSelection: TabBarItem = .readingNow
    
    func getLatestBookReading(for book: Book) -> BookReading? {
        book.bookReadingsArray.sorted(by: { $0.date_finished > $1.date_finished }).first
    }
    
    func getCurrentBookReading(for book: Book) -> BookReading? {
        book.bookReadingsArray.first(where: { $0.isReading && $0.dateFinished == nil && !$0.countToStats })
    }
    
    func getCurrentPage(for book: Book) -> Int {
        Int(book.bookUpdatesArray.sorted { $0.date_added > $1.date_added }.first?.currentPage ?? 0)
    }
    
    func updateProgress(moc: NSManagedObjectContext, for book: Book, pages numberOfPages: Int, notes: String = "") {
        let newUpdate = BookUpdate(context: moc)
        
        newUpdate.id = UUID()
        newUpdate.dateAdded = Date.now
        newUpdate.numberOfPages = Int64(numberOfPages) - Int64(self.getCurrentPage(for: book))
        newUpdate.currentPage = Int64(numberOfPages)
        
        let newNote = Note(context: moc)
            newNote.id = UUID()
            newNote.pageNumber = Int64(numberOfPages)
            newNote.content = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        newNote.book = book
        newNote.bookUpdate = newUpdate
        
        newUpdate.isVisible = true
        newUpdate.countToStats = true
        
        book.addToBookUpdates(newUpdate)
        
        try? moc.save()
    }
    
    func startNewRead(moc: NSManagedObjectContext, for book: Book) {
        resetProgress(moc: moc, for: book)
        
        let newReading = BookReading(context: moc)
        newReading.id = UUID()
        newReading.book = book
        newReading.dateStarted = Date.now
        newReading.isReading = true
        newReading.countToStats = false
        
        try? moc.save()
    }
    
    func resetProgress(moc: NSManagedObjectContext, for book: Book) {
        for update in book.bookUpdatesArray.filter( { $0.isVisible } ) {
            update.isVisible = false
        }
        
        let newUpdate = BookUpdate(context: moc)
        newUpdate.id = UUID()
        newUpdate.dateAdded = Date.now
        newUpdate.numberOfPages = 0
        newUpdate.currentPage = 0
        newUpdate.isVisible = true
        newUpdate.countToStats = false
        
        book.addToBookUpdates(newUpdate)
        book.isRead = false
        book.isReading = true
        
        try? moc.save()
    }
    
    func finish(moc: NSManagedObjectContext, book: Book) {
        resetProgress(moc: moc, for: book)
        
        let currentRead = getCurrentBookReading(for: book)
        currentRead?.isReading = false
        if currentRead?.dateFinished == nil {
            currentRead?.dateFinished = Date.now
        }
        currentRead?.countToStats = true
        
        book.isRead = true
        book.isReading = false
        
        try? moc.save()
    }
}
