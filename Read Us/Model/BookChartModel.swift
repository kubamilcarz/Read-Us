//
//  BookChartModel.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

class BookChartModel {
    var period: ChartPeriod
    
    init(for period: ChartPeriod) {
        self.period = period
    }
    
    func buildSkeleton(with entries: FetchedResults<Entry>) -> [ChartableEntry] {
        var skeleton = makeSkeleton()
        skeleton = populate(skeleton: skeleton, with: entries)
        
        return skeleton
    }
    
    // MARK: - makes empty (in values) skeleton of a chart
    private func makeSkeleton() -> [ChartableEntry] {
        var skeleton = [ChartableEntry]()
        
        switch period {
        case .week:
            skeleton = self.makeChartables(itemCount: 7)
        case .month:
            let dateComponents = DateComponents(year: Date.now.year, month: Date.now.month)
            let date = Calendar.current.date(from: dateComponents)!

            let numberOfDays = Calendar.current.range(of: .day, in: .month, for: date)!.count
            
            skeleton = self.makeChartables(itemCount: numberOfDays)
        case .year:
            skeleton = self.makeChartables(itemCount: 12)
        case .all:
            skeleton = self.makeChartables(itemCount: 5, startingYear: 2018)
        }
        
        return skeleton
    }
    
    // MARK: helper function for makeSkeleton()
    private func makeChartables(itemCount count: Int, startingYear: Int = Date.now.year) -> [ChartableEntry] {
        var skeleton = [ChartableEntry]()
        let pageCount = 0
        
        for i in 0..<count {
            var startDate: Date
            var timeInterval: Int
            
//            pageCount = Int.random(in: 0...50) // DEV
            
            switch period {
            case .week:
                startDate = Date.now.midnight
                timeInterval = 86_400 // 24 hours in seconds
                
                skeleton.append(ChartableEntry(date: startDate.midnight - TimeInterval((timeInterval * i)), pagesRead: pageCount))
            case .month:
                startDate = Date.now.midnight.startOfMonth()
                timeInterval = 86_400 // 24 hours in seconds
                
                skeleton.append(ChartableEntry(date: startDate.midnight + TimeInterval((timeInterval * i)), pagesRead: pageCount))
            case .year:
                // generate first day of month for all 12 months
                let dateComponents = DateComponents(year: startingYear, month: 1 * i, day: 1)
                let calendar = Calendar.current
                startDate = calendar.date(from: dateComponents)!
                
                skeleton.append(ChartableEntry(date: startDate.midnight, pagesRead: pageCount))
            case .all:
                // TODO: - here actually calculate it by getting year of the first entry
                // generate first day of year for given number of years
                let dateComponents = DateComponents(year: startingYear + i, month: 1, day: 1)
                let calendar = Calendar.current
                startDate = calendar.date(from: dateComponents)!
                
                skeleton.append(ChartableEntry(date: startDate.midnight, pagesRead: pageCount))
            }
        }
        
        return skeleton
    }
    
    // MARK: - Populate Skeleton
    private func populate(skeleton: [ChartableEntry], with entries: FetchedResults<Entry>) -> [ChartableEntry] {
        var result = skeleton
        
        switch period {
        case .week:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.midnight }) {
                    result[index].pagesRead += entry.safeNumerOfPagesRead
                }
            }
        case .month:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.midnight }) {
                    result[index].pagesRead += entry.safeNumerOfPagesRead
                }
            }
        case .year:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.startOfMonth() }) {
                    result[index].pagesRead += entry.safeNumerOfPagesRead
                }
            }
        case .all:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.startOfMonth() }) {
                    result[index].pagesRead += entry.safeNumerOfPagesRead
                }
            }
        }
        
        return result
    }
}
