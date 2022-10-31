//
//  CachedBook.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import Foundation

struct CachedBook: Codable, Equatable {
    var title: String
    var author: String
    var isbn10: String
    var isbn13: String
    var photo: Data
    var numberOfPages: String
}
