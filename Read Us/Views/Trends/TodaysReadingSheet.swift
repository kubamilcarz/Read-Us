//
//  TodaysReadingSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/20/22.
//

import Charts
import SwiftUI

struct TodaysReadingSheet: View {
    @Environment(\.dismiss) var dismiss
        
    @FetchRequest<BookUpdate>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ], predicate: NSPredicate(format: "(isVisible == true) AND (dateAdded >= %@) AND (dateAdded < %@)", Date.now.midnight - (604_800) as CVarArg, Date.now as CVarArg)) var entries: FetchedResults<BookUpdate>
    
    @AppStorage("dailyGoal") var dailyGoal = 20
    @AppStorage("HidingExcludedEntriesToggle") private var isHidingExcluded = false
    
    @State private var isShowingUpdateDailyGoalSheet = false
    
    var readTodayHeadline: String {
        let diff = dailyGoal - numberOfPagesReadToday
        
        if diff > 0 {
            return String(localized: "Almost There!")
        } else if diff == 0 {
            return String(localized: "You Hit Your Goal!")
        } else {
            return String(localized: "You Read. A lot!")
        }
    }
    
    var readTodaySubheadline: String {
        let diff = dailyGoal - numberOfPagesReadToday
        
        if diff > 0 {
            return String(localized: "Read \(diff) pages more to hit your goal.")
        } else if diff == 0 {
            return String(localized: "You read \(dailyGoal) pages.")
        } else {
            return String(localized: "And read \(abs(diff)) pages more. A total of \(numberOfPagesReadToday) pages!")
        }
    }
    
    var numberOfPagesReadToday: Int {
        var number = 0
        _ = entries.filter({ $0.date_added.midnight == Date().midnight && $0.isVisible }).map { number += $0.number_of_pages }
        
        return number
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    readToday
                        .padding(.horizontal)
                    
                    Divider()
                    
                    last7Days
                        .padding(.horizontal)
                    
                    Divider()
                    
                    ReadingGoalsSection(for: .today)
                        .padding(.horizontal)
                    
                    Divider()
                    
                    readingLog
                }
            }
            .navigationTitle("Today's Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.ruAccentColor)
                }
            }
            .sheet(isPresented: $isShowingUpdateDailyGoalSheet) {
                UpdateDailyGoalSheet()
                    .presentationDetents([.height(200)])
            }
            
            .tint(.ruAccentColor)
        }
    }
    
    private var readToday: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .top, spacing: 30) {
                CustomCircularProgressView(
                    progress: CGFloat(numberOfPagesReadToday) / CGFloat(dailyGoal),
                    width: 90, borderWidth: 7
                )
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(readTodayHeadline)
                        .font(.system(.title2, design: .serif).bold())
                    Text(readTodaySubheadline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack { Spacer() }
                }
            }
            
            Button("Update Goal") {
                isShowingUpdateDailyGoalSheet = true
            }
            .buttonBorderShape(.capsule)
            .controlSize(.mini)
            .buttonStyle(.bordered)
            .font(.system(size: 10))
        }
        .padding(.top, 40)
        .padding(.bottom, 10)
    }
    
    private var last7Days: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Last 7 Days")
                    .font(.system(.title2, design: .serif))
                    .bold()
                
                Spacer()
            }
            
            BookChart(for: .week, show: .constant(.pages), withDailyGoal: .constant(true))
                .frame(height: 250)
            
        }
    }
    
    private var readingLog: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Reading Log")
                    .font(.system(.title2, design: .serif))
                    .bold()
                
                Spacer()
                
                Button {
                    withAnimation {
                        isHidingExcluded.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .padding(0)
                .font(.subheadline)
                .buttonStyle(.bordered)
                .clipShape(Circle())
                .tint(isHidingExcluded ? .ruAccentColor : .secondary)
            }
            .padding(.horizontal)
            
            ReadingHistorySheet(isSheet: false)
                .frame(minHeight: 300, maxHeight: 900)
            
        }
    }
}
