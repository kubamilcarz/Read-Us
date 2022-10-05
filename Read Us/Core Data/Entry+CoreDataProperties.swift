//
//  Entry+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/4/22.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var currentPage: Int16
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isVisible: Bool
    @NSManaged public var notes: String?
    @NSManaged public var numberOfPages: Int16
    @NSManaged public var book: Book?
    
    public var safeDateAdded: Date { dateAdded ?? Date.now }
    public var safeNotes: String { notes ?? "" }
    public var safeNumerOfPagesRead: Int { Int(numberOfPages) }
    public var safeCurrentPage: Int { Int(currentPage) }

}

extension Entry : Identifiable {

}
