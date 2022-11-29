//
//  ShelfDelegate.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/21/22.
//

import CoreData
import Foundation

extension DataManager {
    static let shelfIcons = ["book", "book.circle", "books.vertical", "books.vertical.circle", "book.closed", "character.book.closed", "text.book.closed", "bookmark", "heart", "star", "moon", "pencil"]
    
    func update(shelf: Shelf, moc: NSManagedObjectContext, title: String?, subtitle: String?, icon: String?) {
        if title?.count ?? 0 > 0 && icon?.count ?? 0 > 0 {
            shelf.title = title
            shelf.subtitle = subtitle
            shelf.icon = icon
            
            if moc.hasChanges {
                try? moc.save()
            }
        }
    }
    
    func add(shelf: Shelf, moc: NSManagedObjectContext, title: String, subtitle: String, icon: String) {
        shelf.id = UUID()
        shelf.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        shelf.subtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
        shelf.icon = icon
        
        try? moc.save()
    }
}
