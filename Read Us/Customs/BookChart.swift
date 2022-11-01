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
    
    @FetchRequest<BookUpdate> private var bookUpdates: FetchedResults<BookUpdate>
    @FetchRequest<Book> private var books: FetchedResults<Book>
    
    init(for period: ChartPeriod, show dataType: Binding<TrendsDataType>, withDailyGoal: Binding<Bool>) {
        self._period = State(wrappedValue: period)
        self._withDailyGoal = Binding(projectedValue: withDailyGoal)
        self._dataType = Binding(projectedValue: dataType)
        self.model = BookChartModel(for: period, show: dataType.wrappedValue)
        
        switch period {
        case .week:
            _bookUpdates = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)
            )
            
//            _books = FetchRequest(
//                sortDescriptors: [SortDescriptor(\.finishedReadingOn, order: .reverse)],
//                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)
//            )
        case .month:
            _bookUpdates = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (2_629_746) as CVarArg, Date.now as CVarArg)
            )
            
//            _books = FetchRequest(
//                sortDescriptors: [SortDescriptor(\.finishedReadingOn, order: .reverse)],
//                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (2_629_746) as CVarArg, Date.now as CVarArg)
//            )
        case .year:
            _bookUpdates = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)],
                predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (31_556_952) as CVarArg, Date.now as CVarArg)
            )
            
//            _books = FetchRequest(
//                sortDescriptors: [SortDescriptor(\.finishedReadingOn, order: .reverse)],
//                predicate: NSPredicate(format: "(finishedReadingOn >= %@) AND (finishedReadingOn < %@)", Date.now.midnight - (31_556_952)  as CVarArg, Date.now as CVarArg)
//            )
        case .all:
            _bookUpdates = FetchRequest(
                sortDescriptors: [SortDescriptor(\.dateAdded, order: .forward)]
            )
            
//            _books = FetchRequest(
//                sortDescriptors: [SortDescriptor(\.finishedReadingOn, order: .forward)]
//            )
        }
        
        _books = FetchRequest(sortDescriptors: [])
    }
    
    var startingYear: Int {
        Date.now.year
    }
    
    @AppStorage("dailyGoal") var dailyGoal = 20
    
    var chartUnit: Calendar.Component {
        switch period {
        case .week:
            return .day
        case .month:
            return .day
        case .year:
            return .month
        case .all:
            return .year
        }
    }
    
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
            
            if period != .all {
                ForEach(skeleton) { entry in
                    BarMark(
                        x: .value("Date", entry.date, unit: chartUnit),
                        y: .value("Pages Read", entry.value),
                        width: .ratio(0.8)
                    )
                    .foregroundStyle(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .topTrailing, endPoint: .bottomLeading))
                }
            } else {
                ForEach(skeleton) { entry in
                    BarMark(
                        x: .value("Pages Read", entry.value),
                        y: .value("Date", entry.date, unit: chartUnit)
                    )
                    .foregroundStyle(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .topTrailing, endPoint: .bottomLeading))
                    .annotation(position: .trailing, alignment: .trailing, spacing: 5) {
                        Text("\(entry.value)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(minHeight: 80)
        .padding(.bottom, 30)
        
        .onAppear {
            switch dataType {
            case .pages:
                if bookUpdates.isEmpty {
                    skeleton = model.buildSkeleton(with: bookUpdates, startingYear: startingYear)
                } else {
                    skeleton = model.buildSkeleton(with: bookUpdates, startingYear: bookUpdates.first!.date_added.year)
                }
            case .bookCount:
                if books.isEmpty {
                    skeleton = model.buildSkeleton(with: books, startingYear: startingYear)
                } else {
                    skeleton = model.buildSkeleton(with: books, startingYear: books.first!.bookReadingsArray.first?.date_finished.year ?? Date.now.year)
                }
            }
        }
        
        .onChange(of: dataType) { _ in
            switch dataType {
            case .pages:
                if bookUpdates.isEmpty {
                    skeleton = model.buildSkeleton(with: bookUpdates, startingYear: startingYear)
                } else {
                    skeleton = model.buildSkeleton(with: bookUpdates, startingYear: bookUpdates.first!.date_added.year)
                }
            case .bookCount:
                if books.isEmpty {
                    skeleton = model.buildSkeleton(with: books, startingYear: startingYear)
                } else {
                    skeleton = model.buildSkeleton(with: books, startingYear: books.first!.bookReadingsArray.first?.date_finished.year ?? Date.now.year)
                }
            }
        }
    }
}

