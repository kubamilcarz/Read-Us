//
//  CachedBook.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import Foundation

struct CachedBook: Codable, Identifiable {
    var id: String
    var title: String
    var author: String
    var isbn10: String
    var isbn13: String
}

struct FetchedBooks: Codable {
    var kind: String
    var totalItems: Int
    
    var items: [GBook]
}

struct GBook: Codable {
    var kind: String
    var id: String
    var etag: String
    var selfLink: String
}

struct NYTISBNS: Codable {
    var isbn10: String
    var isbn13: String
}

struct NYTBook: Codable {
    var title: String
    var description: String
    var contributor: String
    var author: String
    var contributor_note: String
    var price: String
    var age_group: String
    var publisher: String
    var primary_isbn13: String
    var primary_isbn10: String
}
