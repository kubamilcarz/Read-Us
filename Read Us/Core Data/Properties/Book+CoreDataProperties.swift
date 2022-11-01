//
//  Book+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import UIKit
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isRead: Bool
    @NSManaged public var isReading: Bool
    @NSManaged public var numberOfPages: Int64
    @NSManaged public var cover: Data?
    @NSManaged public var title: String?
    @NSManaged public var quotes: NSSet?
    @NSManaged public var shelves: NSSet?
    @NSManaged public var notes: NSSet?
    @NSManaged public var tags: NSSet?
    @NSManaged public var bookReadings: NSSet?
    @NSManaged public var bookUpdates: NSSet?
    
    public var author_string: String { author ?? "" }
    public var title_string: String { title ?? "" }
    public var number_of_pages: Int { Int(numberOfPages) }
    public var is_read: Bool { isRead }
    public var is_reading: Bool { isReading }
    public var date_added: Date { dateAdded ?? Date.now }
    public var cover_image: UIImage { UIImage(data: cover ?? Data()) ?? UIImage(systemName: "photo.on.rectangle")! }
    
    public var quotesArray: [Quote] {
        Array(quotes as? Set<Quote> ?? [])
    }
    
    public var shelvesArray: [Shelf] {
        Array(shelves as? Set<Shelf> ?? [])
    }
    
    public var notesArray: [Note] {
        Array(notes as? Set<Note> ?? [])
    }
    
    public var tagsArray: [Tag] {
        Array(tags as? Set<Tag> ?? [])
    }
    
    public var bookReadingsArray: [BookReading] {
        Array(bookReadings as? Set<BookReading> ?? [])
    }
    
    public var bookUpdatesArray: [BookUpdate] {
        Array(bookUpdates as? Set<BookUpdate> ?? [])
    }

}

// MARK: Generated accessors for quotes
extension Book {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quote)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quote)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}

// MARK: Generated accessors for shelves
extension Book {

    @objc(addShelvesObject:)
    @NSManaged public func addToShelves(_ value: Shelf)

    @objc(removeShelvesObject:)
    @NSManaged public func removeFromShelves(_ value: Shelf)

    @objc(addShelves:)
    @NSManaged public func addToShelves(_ values: NSSet)

    @objc(removeShelves:)
    @NSManaged public func removeFromShelves(_ values: NSSet)

}

// MARK: Generated accessors for notes
extension Book {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Book {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for bookReadings
extension Book {

    @objc(addBookReadingsObject:)
    @NSManaged public func addToBookReadings(_ value: BookReading)

    @objc(removeBookReadingsObject:)
    @NSManaged public func removeFromBookReadings(_ value: BookReading)

    @objc(addBookReadings:)
    @NSManaged public func addToBookReadings(_ values: NSSet)

    @objc(removeBookReadings:)
    @NSManaged public func removeFromBookReadings(_ values: NSSet)

}

// MARK: Generated accessors for bookUpdates
extension Book {

    @objc(addBookUpdatesObject:)
    @NSManaged public func addToBookUpdates(_ value: BookUpdate)

    @objc(removeBookUpdatesObject:)
    @NSManaged public func removeFromBookUpdates(_ value: BookUpdate)

    @objc(addBookUpdates:)
    @NSManaged public func addToBookUpdates(_ values: NSSet)

    @objc(removeBookUpdates:)
    @NSManaged public func removeFromBookUpdates(_ values: NSSet)

}

extension Book : Identifiable {

}
