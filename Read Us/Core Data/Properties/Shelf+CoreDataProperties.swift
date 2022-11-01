//
//  Shelf+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
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
    
    public var icon_string: String { icon ?? "" }
    public var subtitle_string: String { subtitle ?? "" }
    public var title_string: String { title ?? "" }
    
    public var booksArray: [Book] {
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
