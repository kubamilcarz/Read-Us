//
//  TabBarItem.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

enum TabBarItem: Hashable {
    case readingNow, library, trends, profile
    
    var iconName: String {
        switch self {
        case .readingNow: return "book"
        case .library: return "books.vertical"
        case .trends: return "chart.bar"
        case .profile: return "person.circle"
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .readingNow: return "Reading Now"
        case .library: return "Library"
        case .trends: return "Trends"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .readingNow: return Color.accentColor
        case .library: return Color.accentColor
        case .trends: return Color.accentColor
        case .profile: return Color.accentColor
        }
    }
}
