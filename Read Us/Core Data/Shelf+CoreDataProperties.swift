//
//  Shelf+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/6/22.
//
//

import Foundation
import CoreData


extension Shelf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shelf> {
        return NSFetchRequest<Shelf>(entityName: "Shelf")
    }

    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var books: NSSet?

    public var safeTitle: String { title ?? "Untitled" }
        
    public var safeSubtitle: String { subtitle ?? "" }
    
    public var safeIcon: String { icon ?? "books.vertical.circle" }
    
    public var safeBooks: [Book] {
        Array(books as? Set<Book> ?? [])
    }
    
}

// MARK: Generated accessors for books
extension Shelf {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

extension Shelf : Identifiable {

}
