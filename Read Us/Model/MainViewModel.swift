//
//  MainViewModel.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import CoreData
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var tabSelection: TabBarItem = .trends
    
    func getCurrentPage(for book: Book) -> Int {
        Int(book.safeEntries.sorted { $0.safeDateAdded > $1.safeDateAdded }.first?.currentPage ?? 0)
    }
    
    func updateProgress(moc: NSManagedObjectContext, for book: Book, pages numberOfPages: Int, notes: String = "") {
        let newEntry = Entry(context: moc)
        newEntry.id = UUID()
        newEntry.dateAdded = Date.now
        newEntry.numberOfPages = Int16(numberOfPages) - Int16(self.getCurrentPage(for: book))
        newEntry.currentPage = Int16(numberOfPages)
        newEntry.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        newEntry.isVisible = true
        
        book.addToEntries(newEntry)
        
        try? moc.save()
    }
    
    func resetProgress(moc: NSManagedObjectContext, for book: Book) {
        for entry in book.safeEntries.filter({$0.isVisible}) {
            entry.isVisible = false
        }
        
        let newEntry = Entry(context: moc)
        newEntry.id = UUID()
        newEntry.dateAdded = Date.now
        newEntry.numberOfPages = 0
        newEntry.currentPage = 0
        newEntry.notes = ""
        newEntry.isVisible = true
        
        book.addToEntries(newEntry)
        book.isRead = false
        book.isReading = true
        
        try? moc.save()
    }
    
    func finish(moc: NSManagedObjectContext, book: Book) {
        resetProgress(moc: moc, for: book)
        book.isRead = true
        book.isReading = false
        
        try? moc.save()
    }
}
