//
//  TodaysReadingSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/20/22.
//

import Charts
import SwiftUI

struct ChartableEntry: Identifiable {
    var id = UUID()
    var date: Date
    var pagesRead: Int
}

struct TodaysReadingSheet: View {
    @Environment(\.dismiss) var dismiss
        
    @FetchRequest<Entry>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ], predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)) var entries: FetchedResults<Entry>
    
    var filteredEntries: [ChartableEntry] {
        var result: [ChartableEntry] = []
        
        if entries.isEmpty { return result }
                
        var currentMidnight = entries[0].safeDateAdded.midnight
        result.append(ChartableEntry(date: currentMidnight, pagesRead: 0))
        
        for entry in entries {
            if result.filter({ $0.date == currentMidnight }).isEmpty {
                result.append(ChartableEntry(date: currentMidnight, pagesRead: 0))
            }
            
            if result.filter({$0.date == entry.safeDateAdded.midnight }).isEmpty {
                result.append(ChartableEntry(
                    date: entry.safeDateAdded.midnight,
                    pagesRead: entry.safeNumerOfPagesRead
                ))
            } else {
                do {
                    let index = try result.firstIndex(where: { $0.date == entry.safeDateAdded.midnight })!
                    result[index].pagesRead += entry.safeNumerOfPagesRead
                } catch {
                    result.append(
                        ChartableEntry(date: entry.safeDateAdded.midnight, pagesRead: entry.safeNumerOfPagesRead)
                    )
                }
                
            }
            
//            if entry.safeDateAdded.midnight == currentMidnight {
//                if result.first(where: { $0.date.midnight = currentMidnight })
//            }
            
            
//            if result[currentMidnight] == nil {
//                result[currentMidnight] = []
//            }
//
//            if entry.safeDateAdded.midnight == currentMidnight {
//                result[currentMidnight]!.append(entry)
//            } else {
//                currentMidnight = entry.safeDateAdded.midnight
//            }
            
//            for entry in entries {
//                if result[currentMidnight] == nil {
//                    result[currentMidnight] = ChartableEntry(pagesRead: 0)
//                }
//
//                if entry.safeDateAdded.midnight == currentMidnight {
//                    result[currentMidnight]! = ChartableEntry(pagesRead: result[currentMidnight]!.pagesRead + entry.safeNumerOfPagesRead)
//                } else {
//                    currentMidnight = entry.safeDateAdded.midnight
//                }
//            }
        }
        
        return result
    }
    
    @AppStorage("dailyGoal") var dailyGoal = 20
    
    var numberOfPagesReadToday: Int {
        var number = 0
        _ = entries.filter({ $0.safeDateAdded.midnight == Date().midnight && $0.isVisible }).map { number += $0.safeNumerOfPagesRead }
        
        return number
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    
                    readToday
                    
                    last7Days
                    
                    ReadingHistorySheet()
                        .padding(.top, 200)
                }
            }
            .navigationTitle("Today's Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .tint(.ruAccentColor)
        }
    }
    
    private var readToday: some View {
        ZStack {
            CustomCircularProgressView(progress: CGFloat(numberOfPagesReadToday) / CGFloat(dailyGoal), width: 150, borderWidth: 9)
            
            Text("\(numberOfPagesReadToday) / \(dailyGoal)")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 30)
    }
    
    private var last7Days: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Last 7 Days")
                    .font(.system(.headline, design: .serif))
                
                Spacer()
            }
            
            Chart(filteredEntries) { entry in
                BarMark(
                    x: .value("Date", entry.date, unit: .day),
                    y: .value("Pages Read", entry.pagesRead)
                )
            }
            .frame(minHeight: 250)
            
        }
        .padding(.horizontal)
    }
}

struct TodaysReadingSheet_Previews: PreviewProvider {
    static var previews: some View {
        TodaysReadingSheet()
    }
}
