//
//  Session+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var duration: Double
    @NSManaged public var actualDuration: Double
    @NSManaged public var wasFinished: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var notes: NSSet?
    @NSManaged public var quotes: NSSet?

    public var date_added: Date { dateAdded ?? Date.now }
    
    public var notesArray: [Note] {
        Array(notes as? Set<Note> ?? [])
    }
    
    public var quotesArray: [Quote] {
        Array(quotes as? Set<Quote> ?? [])
    }
    
}

// MARK: Generated accessors for notes
extension Session {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for quotes
extension Session {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quote)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quote)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}

extension Session : Identifiable {

}
