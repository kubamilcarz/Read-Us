//
//  BookChart.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import Charts
import SwiftUI

struct BookChart: View {
    @State private var skeleton = [ChartableEntry]()
    @State private var period: ChartPeriod
    var withDailyGoal: Bool
    var model: BookChartModel
    
    @FetchRequest<Entry> var entries: FetchedResults<Entry>
    
    init(for period: ChartPeriod, withDailyGoal: Bool = false) {
        self._period = State(wrappedValue: period)
        self.withDailyGoal = withDailyGoal
        self.model = BookChartModel(for: period)
        
        switch period {
        case .week:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)
            )
        case .month:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (2_629_746) as CVarArg, Date.now as CVarArg)
            )
        case .year:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (31_556_952) as CVarArg, Date.now as CVarArg)
            )
        case .all:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (31_556_952) as CVarArg, Date.now as CVarArg)
            )
        }
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
        .onAppear {
            skeleton = model.buildSkeleton(with: entries)

            
            for bone in skeleton {
                print("bone \(bone.date.formatted(date: .abbreviated, time: .shortened)) holds \(bone.pagesRead)")
            }
        }
    }
}

