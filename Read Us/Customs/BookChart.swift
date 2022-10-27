//
//  BookChart.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import Charts
import SwiftUI

struct BookChart: View {
    @FetchRequest<Entry>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ], predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)) var entries: FetchedResults<Entry>
    
    var skeleton: [ChartableEntry]
    @State private var period: ChartPeriod
    var withDailyGoal: Bool
    
    init(for period: ChartPeriod, withDailyGoal: Bool = false) {
        self._period = State(wrappedValue: period)
        self.withDailyGoal = withDailyGoal
        self.skeleton = BookChartModel.makeSkeleton(for: period)
    }
    
    @AppStorage("dailyGoal") var dailyGoal = 20
    
    var body: some View {
        Chart {
            if withDailyGoal {
                RuleMark(y: .value("Pages Read", dailyGoal))
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Daily Goal")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .padding(.trailing, 5)
                    }
                    .foregroundStyle(Color.ruAccentColor)
                    .opacity(0.7)
            }
            
            ForEach(skeleton) { entry in
                if period != .all {
                    BarMark(
                        x: .value("Date", entry.date, unit: period == .week || period == .month ? .day : (period == .year ? .month : .year)),
                        y: .value("Pages Read", entry.pagesRead)
                    )
                    .foregroundStyle(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .topTrailing, endPoint: .bottomLeading))
                } else {
                    BarMark(
                        x: .value("Pages Read", entry.pagesRead),
                        y: .value("Date", entry.date, unit: period == .week || period == .month ? .day : (period == .year ? .month : .year))
                    )
                    .foregroundStyle(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .topTrailing, endPoint: .bottomLeading))
                }
            }
        }
    }
}

