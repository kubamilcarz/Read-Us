//
//  ChartableEntry.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import Foundation

struct ChartableEntry: Identifiable {
    var id = UUID()
    var date: Date
    var value: Int // either pages count or book count
}
