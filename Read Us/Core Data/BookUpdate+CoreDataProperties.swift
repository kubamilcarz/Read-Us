//
//  BookUpdate+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import CoreData


extension BookUpdate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookUpdate> {
        return NSFetchRequest<BookUpdate>(entityName: "BookUpdate")
    }

    @NSManaged public var currentPage: Int64
    @NSManaged public var countToStats: Bool
    @NSManaged public var isVisible: Bool
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var numberOfPages: Int64
    @NSManaged public var note: Note?
    @NSManaged public var book: Book?
    
    public var current_page: Int { Int(currentPage) }
    public var number_of_pages: Int { Int(numberOfPages) }
    public var count_to_stats: Bool { countToStats }
    public var is_visible: Bool { isVisible }
    public var date_added: Date { dateAdded ?? Date.now }

}

extension BookUpdate : Identifiable {

}
