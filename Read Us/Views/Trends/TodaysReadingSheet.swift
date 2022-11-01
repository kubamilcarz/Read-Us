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
                VStack(spacing: 0) {
                    
                    readToday
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(.background)
                            .padding(.top, -30)
                            
                            
                        last7Days
                    }
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.background)
                            .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .padding(.top, -30)
                        
                        ReadingGoalsSection(for: .today)
                            .padding(.horizontal)
                            .padding(.vertical, 30)
                    }
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(.background)
                            .padding(.top, -30)
                            
                            
                        readingLog
                    }
                }
            }
            .background(.ultraThinMaterial)
            .navigationTitle("Today's Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
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
        .padding(30)
    }
    
    private var last7Days: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Last 7 Days")
                    .font(.system(.headline, design: .serif))
                
                Spacer()
            }
            
            BookChart(for: .week, show: .constant(.pages), withDailyGoal: .constant(true))
                .padding(.horizontal)
                .frame(height: 250)
            
        }
        .padding(.vertical, 30)
        .padding(.horizontal)
        .background(.background)
    }
    
    private var readingLog: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Reading Log")
                    .font(.system(.headline, design: .serif))
                
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
        .padding(.vertical, 30)
        .background(.background)
    }
}
