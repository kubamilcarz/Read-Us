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
    @Binding var dataType: TrendsDataType
    @Binding var withDailyGoal: Bool
    private var model: BookChartModel
    
    @FetchRequest<Entry> private var entries: FetchedResults<Entry>
    @FetchRequest<Book> private var books: FetchedResults<Book>
    
    init(for period: ChartPeriod, show dataType: Binding<TrendsDataType>, withDailyGoal: Binding<Bool>) {
        self._period = State(wrappedValue: period)
        self._withDailyGoal = Binding(projectedValue: withDailyGoal)
        self._dataType = Binding(projectedValue: dataType)
        self.model = BookChartModel(for: period, show: dataType.wrappedValue)
        
        switch period {
        case .week:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)
            )
            
            _books = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)
            )
        case .month:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (2_629_746) as CVarArg, Date.now as CVarArg)
            )
            
            _books = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (2_629_746) as CVarArg, Date.now as CVarArg)
            )
        case .year:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (31_556_952) as CVarArg, Date.now as CVarArg)
            )
            
            _books = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (31_556_952)  as CVarArg, Date.now as CVarArg)
            )
        case .all:
            _entries = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (31_556_952) as CVarArg, Date.now as CVarArg)
            )
            
            _books = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (31_556_952) as CVarArg, Date.now as CVarArg)
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
                        y: .value("Pages Read", entry.value)
                    )
                    .foregroundStyle(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .topTrailing, endPoint: .bottomLeading))
                } else {
                    BarMark(
                        x: .value("Pages Read", entry.value),
                        y: .value("Date", entry.date, unit: period == .week || period == .month ? .day : (period == .year ? .month : .year))
                    )
                    .foregroundStyle(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .topTrailing, endPoint: .bottomLeading))
                }
            }
        
            
        }
        .frame(minHeight: 250)
        .onAppear {
            switch dataType {
            case .pages:
                if entries.isEmpty {
                    skeleton = model.buildSkeleton(with: entries, startingYear: Date.now.year)
                } else {
                    skeleton = model.buildSkeleton(with: entries, startingYear: entries.first!.safeDateAdded.year)
                }
            case .bookCount:
                if books.isEmpty {
                    skeleton = model.buildSkeleton(with: books, startingYear: Date.now.year)
                } else {
                    skeleton = model.buildSkeleton(with: books, startingYear: entries.first!.safeDateAdded.year)
                }
            }
        }
        .onChange(of: dataType) { _ in
            switch dataType {
            case .pages:
                if entries.isEmpty {
                    skeleton = model.buildSkeleton(with: entries, startingYear: Date.now.year)
                } else {
                    skeleton = model.buildSkeleton(with: entries, startingYear: entries.first!.safeDateAdded.year)
                }
            case .bookCount:
                if books.isEmpty {
                    skeleton = model.buildSkeleton(with: books, startingYear: Date.now.year)
                } else {
                    skeleton = model.buildSkeleton(with: books, startingYear: entries.first!.safeDateAdded.year)
                }
            }
        }
    }
}

