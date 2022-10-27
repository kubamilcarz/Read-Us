//
//  BookChartModel.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

class BookChartModel {
    
    // MARK: - makes empty (in values) skeleton of a chart
    static public func makeSkeleton(for period: ChartPeriod) -> [ChartableEntry] {
        var skeleton = [ChartableEntry]()
        
        switch period {
        case .week:
            skeleton = self.makeChartables(itemCount: 7, period: period)
        case .month:
            let dateComponents = DateComponents(year: Date.now.year, month: Date.now.month)
            let date = Calendar.current.date(from: dateComponents)!

            let numberOfDays = Calendar.current.range(of: .day, in: .month, for: date)!.count
            
            skeleton = self.makeChartables(itemCount: numberOfDays, period: period)
        case .year:
            skeleton = self.makeChartables(itemCount: 12, period: period)
        case .all:
            skeleton = self.makeChartables(itemCount: 5, period: period, startingYear: 2018)
        }
        
        return skeleton
    }
    
    // MARK: helper function for makeSkeleton()
    static private func makeChartables(itemCount count: Int, period: ChartPeriod, startingYear: Int = Date.now.year) -> [ChartableEntry] {
        var skeleton = [ChartableEntry]()
        var pageCount = 0
        
        for i in 1..<count {
            var startDate: Date
            var timeInterval: Int
            
            pageCount = Int.random(in: 10...40) // DEV
            
            switch period {
            case .week:
                startDate = Date.now.midnight
                timeInterval = 86_400 // 24 hours in seconds
                
                skeleton.append(ChartableEntry(date: startDate.midnight - TimeInterval((timeInterval * i)), pagesRead: pageCount))
            case .month:
                startDate = Date.now.midnight.startOfMonth()
                timeInterval = 86_400 // 24 hours in seconds
                
                skeleton.append(ChartableEntry(date: startDate.midnight - TimeInterval((timeInterval * i)), pagesRead: pageCount))
            case .year:
                // generate first day of month for all 12 months
                let dateComponents = DateComponents(year: startingYear, month: 1 * i, day: 1)
                let calendar = Calendar.current
                startDate = calendar.date(from: dateComponents)!
                
                skeleton.append(ChartableEntry(date: startDate.midnight, pagesRead: pageCount))
            case .all:
                // TODO: - here actually calculate it by getting year of the first entry
                // generate first day of year for given number of years
                let dateComponents = DateComponents(year: startingYear + i - 1, month: 1, day: 1)
                let calendar = Calendar.current
                startDate = calendar.date(from: dateComponents)!
                
                skeleton.append(ChartableEntry(date: startDate.midnight, pagesRead: pageCount))
            }
        }
        
        return skeleton
    }
    
    // MARK: - Populate Skeleton
    static public func populate(skeleton: [ChartableEntry], with entries: [Entry]) -> [ChartableEntry] {
        
        return skeleton
    }
}
