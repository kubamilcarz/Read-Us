//
//  BookReading+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import CoreData


extension BookReading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookReading> {
        return NSFetchRequest<BookReading>(entityName: "BookReading")
    }

    @NSManaged public var dateStarted: Date?
    @NSManaged public var dateFinished: Date?
    @NSManaged public var review: String?
    @NSManaged public var rating: Int64
    @NSManaged public var countToStats: Bool
    @NSManaged public var isReading: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var notes: NSSet?
    @NSManaged public var book: Book?

    public var date_started: Date { dateStarted ?? Date.now }
    public var date_finished: Date { dateFinished ?? Date.now }
    public var is_reading: Bool { isReading }
    public var count_to_stats: Bool { countToStats }
    public var review_string: String { review ?? "" }
    public var rating_int: Int { Int(rating) }
    
    public var noteArray: [Note] {
        Array(notes as? Set<Note> ?? [])
    }
    
}

// MARK: Generated accessors for notes
extension BookReading {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension BookReading : Identifiable {

}
