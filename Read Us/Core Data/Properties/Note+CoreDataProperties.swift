//
//  Note+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var pageNumber: Int64
    @NSManaged public var content: String?
    @NSManaged public var id: UUID?
    @NSManaged public var book: Book?
    @NSManaged public var session: Session?
    @NSManaged public var bookUpdate: BookUpdate?
    @NSManaged public var bookReading: BookReading?
    
    public var date_added: Date { dateAdded ?? Date.now }
    public var page_number: Int { Int(pageNumber) }
    public var content_string: String { content ?? "" }

}

extension Note : Identifiable {

}
