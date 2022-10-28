//
//  BookChartModel.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

class BookChartModel {
    var period: ChartPeriod
    var dataType: TrendsDataType
    
    init(for period: ChartPeriod, show dataType: TrendsDataType) {
        self.period = period
        self.dataType = dataType
    }
    
    func buildSkeleton(with entries: FetchedResults<Entry>, startingYear: Int) -> [ChartableEntry] {
        var skeleton = makeSkeleton(startingYear: startingYear)
        skeleton = populate(skeleton: skeleton, with: entries)
        
        return skeleton
    }
    
    func buildSkeleton(with books: FetchedResults<Book>, startingYear: Int) -> [ChartableEntry] {
        var skeleton = makeSkeleton(startingYear: startingYear)
        skeleton = populate(skeleton: skeleton, with: books)
        
        return skeleton
    }
    
    // MARK: - makes empty (in values) skeleton of a chart
    private func makeSkeleton(startingYear: Int) -> [ChartableEntry] {
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
            skeleton = self.makeChartables(itemCount: Date.now.year - startingYear == 0 ? 1 : Date.now.year - startingYear > 0 ? Date.now.year - startingYear : 1, startingYear: startingYear)
        }
        
        return skeleton
    }
    
    // MARK: helper function for makeSkeleton()
    private func makeChartables(itemCount count: Int, startingYear: Int = Date.now.year) -> [ChartableEntry] {
        var skeleton = [ChartableEntry]()
        
        var startDate: Date
        var timeInterval: Int
        
        for i in 0..<count {
            switch period {
            case .week:
                startDate = Date.now.midnight
                timeInterval = 86_400 // 24 hours in seconds
                
                skeleton.append(ChartableEntry(date: startDate - TimeInterval((timeInterval * i)), value: 0))
            case .month:
                startDate = Date.now.midnight.startOfMonth()
                timeInterval = 86_400 // 24 hours in seconds
                
                skeleton.append(ChartableEntry(date: startDate + TimeInterval((timeInterval * i)), value: 0))
            case .year:
                // generate first day of month for all 12 months
                let dateComponents = DateComponents(year: startingYear, month: 1 * i, day: 1)
                let calendar = Calendar.current
                startDate = calendar.date(from: dateComponents)!.midnight
                
                skeleton.append(ChartableEntry(date: startDate, value: 0))
            case .all:
                // generate first day (jan 1) for given number of years
                let dateComponents = DateComponents(year: startingYear + i, month: 1, day: 1)
                let calendar = Calendar.current
                startDate = calendar.date(from: dateComponents)!.midnight
                
                skeleton.append(ChartableEntry(date: startDate, value: 0))
            }
        }
        
        return skeleton
    }
    
    // MARK: - Populate with Entries
    private func populate(skeleton: [ChartableEntry], with entries: FetchedResults<Entry>) -> [ChartableEntry] {
        var result = skeleton
        
        switch period {
        case .week:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.midnight }) {
                    result[index].value += entry.safeNumerOfPagesRead
                }
            }
        case .month:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.midnight }) {
                    result[index].value += entry.safeNumerOfPagesRead
                }
            }
        case .year:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.startOfMonth() }) {
                    result[index].value += entry.safeNumerOfPagesRead
                }
            }
        case .all:
            for entry in entries {
                if let index = result.firstIndex(where: { $0.date == entry.safeDateAdded.startOfYear() }) {
                    result[index].value += entry.safeNumerOfPagesRead
                }
            }
        }
        
        return result
    }
    
    // MARK: - Populate with Books
    private func populate(skeleton: [ChartableEntry], with books: FetchedResults<Book>) -> [ChartableEntry] {
        var result = skeleton
        
        switch period {
        case .week:
            result = []
        case .month:
            for book in books {
                if let index = result.firstIndex(where: { $0.date == book.safeFinishedReadingOn.midnight }) {
                    result[index].value += 1
                }
            }
        case .year:
            for book in books {
                if let index = result.firstIndex(where: { $0.date == book.safeFinishedReadingOn.startOfYear() }) {
                    result[index].value += 1
                }
            }
        case .all:
            for book in books {
                if let index = result.firstIndex(where: { $0.date == book.safeFinishedReadingOn.startOfYear() }) {
                    result[index].value += 1
                }
            }
        }
        
        return result
    }
}
