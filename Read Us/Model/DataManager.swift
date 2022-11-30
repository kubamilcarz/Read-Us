//
//  MainViewModel.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import CoreData
import SwiftUI

class DataManager: ObservableObject {
    @Published var tabSelection: TabBarItem = .readingNow

    func pauseCurrentReading(moc: NSManagedObjectContext, for book: Book) {
        // check if the book is curerntly being read
        if let currentReading = getCurrentBookReading(for: book) {
            book.isReading = false
            
            currentReading.isReading = false
            currentReading.countToStats = false
            try? moc.save()
        }
    }
    
    func unpauseCurrentReading(moc: NSManagedObjectContext, for book: Book) {
        // check if the book is curerntly being read
        if let currentReading = getCurrentBookReading(for: book) {
            book.isReading = true
            
            currentReading.isReading = true
            currentReading.countToStats = false
            try? moc.save()
        }
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
        
        updateBookReading(moc: moc, for: book)
        
        newUpdate.isVisible = true
        newUpdate.countToStats = true
        
        book.addToBookUpdates(newUpdate)
        
        try? moc.save()
    }
    
    func updateBookReading(moc: NSManagedObjectContext, for book: Book) {
        guard getCurrentBookReading(for: book) == nil else { return }
        
        let newBookReading = BookReading(context: moc)
        newBookReading.id = UUID()
        newBookReading.countToStats = true
        newBookReading.dateStarted = Date.now
        newBookReading.isReading = true
        newBookReading.book = book
        
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
    
    func resetProgress(moc: NSManagedObjectContext, for book: Book, resetBookToReading: Bool = true) {
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
        if resetBookToReading {
            book.isRead = false
            book.isReading = true
        }
        
        try? moc.save()
    }
    
    func finish(moc: NSManagedObjectContext, book: Book) {
        resetProgress(moc: moc, for: book, resetBookToReading: false)
        
        getCurrentBookReading(for: book)?.isReading = false
        getCurrentBookReading(for: book)?.countToStats = true
        getCurrentBookReading(for: book)?.dateFinished = getCurrentBookReading(for: book)?.dateFinished ?? Date.now
        
        
        book.isRead = true
        book.isReading = false
        
        try? moc.save()
    }
}
