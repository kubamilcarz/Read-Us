//
//  Date.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/28/22.
//

import Foundation

extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(
          from: self,
          dateStyle: dateStyle,
          timeStyle: timeStyle)
    }

    var midnight: Date {
        let cal = Calendar(identifier: Locale().calendar.identifier)
        return cal.startOfDay(for: self)
    }
    
    var year: Int {
        let cal = Calendar(identifier: Locale().calendar.identifier)
        return cal.component(.year, from: self)
    }
    
    var month: Int {
        let cal = Calendar(identifier: Locale().calendar.identifier)
        return cal.component(.month, from: self)
    }
    
    var day: Int {
        let cal = Calendar(identifier: Locale().calendar.identifier)
        return cal.component(.day, from: self)
    }
    
    func startOfMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func startOfYear() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
}
