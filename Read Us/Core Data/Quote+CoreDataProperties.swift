//
//  Quote+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/27/22.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var pageNumber: Int16
    @NSManaged public var book: Book?
    
    public var safeContent: String { content ?? "Untitled" }
    
    public var safeDateAdded: Date { dateAdded ?? Date.now }

    public var safePageNumber: Int { Int(pageNumber) }
}

extension Quote : Identifiable {

}
