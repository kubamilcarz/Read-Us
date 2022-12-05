//
//  BackupBook.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/5/22.
//

import Foundation

struct BackupBook: Codable {
    var title: String
    var author: String
    var cover: Data
    var numberOfPages: Int
    var dateAdded: Date
}
