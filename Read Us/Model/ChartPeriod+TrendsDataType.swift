//
//  ChartPeriod.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

enum ChartPeriod {
    case week, month, year, all
}

enum TrendsDataType: LocalizedStringKey, CaseIterable {
    case pages = "pages", bookCount = "books"
}
