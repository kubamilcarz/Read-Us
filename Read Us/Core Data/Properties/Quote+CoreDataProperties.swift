//
//  Quote+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var content: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var pageNumber: Int64
    @NSManaged public var book: Book?
    @NSManaged public var session: Session?

    public var content_string: String { content ?? "" }
    public var date_added: Date { dateAdded ?? Date.now }
    public var page_number: Int { Int(pageNumber) }
    
}

extension Quote : Identifiable {

}
