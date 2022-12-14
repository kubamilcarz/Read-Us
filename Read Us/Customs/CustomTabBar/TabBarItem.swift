//
//  TabBarItem.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

enum TabBarItem: Hashable {
    case readingNow, library, trends, bookLog
    
    var iconName: String {
        switch self {
        case .readingNow: return "book"
        case .library: return "books.vertical"
        case .trends: return "chart.bar"
        case .bookLog: return "list.bullet.below.rectangle"
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .readingNow: return "Reading Now"
        case .library: return "Library"
        case .trends: return "Trends"
        case .bookLog: return "Log"
        }
    }
    
    var color: Color {
        .ruAccentColor
    }
}
