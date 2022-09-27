//
//  Book+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/27/22.
//
//

import Foundation
import CoreData
import UIKit


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var isRead: Bool
    @NSManaged public var notes: String?
    @NSManaged public var numberOfPages: Int16
    @NSManaged public var startedReadingOn: Date?
    @NSManaged public var finishedReadingOn: Date?
    @NSManaged public var tags: [String]?
    @NSManaged public var photo: Data?
    @NSManaged public var rating: Int16
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isReading: Bool
    @NSManaged public var entries: NSSet?
    @NSManaged public var quotes: NSSet?
    
    public var safeTitle: String { title ?? "Untitled" }
    
    public var safeAuthor: String { author ?? "Anonymous Anonymous" }
    
    public var safeNotes: String { notes ?? "" }
    
    public var safeRating: Int { Int(rating) }
    
    public var safeNumberOfPages: Int { Int(numberOfPages) }
    
    public var safePhoto: UIImage { UIImage(data: photo ?? Data()) ?? UIImage(systemName: "photo.on.rectangle")! }
    
    public var safeDateAdded: Date { dateAdded ?? Date.now }
    
    public var safeStartedReadingOn: Date { startedReadingOn ?? Date.now }
    
    public var safeFinishedReadingOn: Date { finishedReadingOn ?? Date.now }
    
    public var safeTags: [String] { tags ?? [] }
    
    public var qoutesArray: [Quote] {
        let set = quotes as? Set<Quote> ?? []
        
        return Array(set)
    }
    
    public var safeEntries: [Entry] {
        let set = entries as? Set<Entry> ?? []
        
        return Array(set)
    }

}

// MARK: Generated accessors for entries
extension Book {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

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

extension Book : Identifiable {

}
