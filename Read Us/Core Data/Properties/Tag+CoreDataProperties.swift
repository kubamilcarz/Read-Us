//
//  Tag+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/1/22.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var books: NSSet?
    
    public var title_string: String { title ?? "" }
    public var bookArray: [Book] {
        Array(books as? Set<Book> ?? [])
    }

}

// MARK: Generated accessors for books
extension Tag {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

extension Tag : Identifiable {

}
