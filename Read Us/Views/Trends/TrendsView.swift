//
//  TrendsView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

struct TrendsView: View {
    @State private var trendsDataType: TrendsDataType = .pages
    
    @State private var withDailyGoal = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    if trendsDataType == .pages {
                        VStack(alignment: .leading) {
                            BookieSectionHeader("Last 7 Days")
                            
                            BookChart(for: .week, show: $trendsDataType, withDailyGoal: $withDailyGoal)
                                .frame(minHeight: 250)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            BookieSectionHeader("This Month")
                            
                            BookChart(for: .month, show: $trendsDataType, withDailyGoal: $withDailyGoal)
                                .frame(minHeight: 250)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        BookieSectionHeader("This Year")
                        
                        BookChart(for: .year, show: $trendsDataType, withDailyGoal: .constant(false))
                            .frame(minHeight: 250)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        BookieSectionHeader("All")
                        
                        BookChart(for: .all, show: $trendsDataType, withDailyGoal: .constant(false))
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 75)
            }
            .navigationTitle("Trends")
            
            .onChange(of: trendsDataType) { _ in
                if trendsDataType == .pages {
                    withDailyGoal = true
                } else {
                    withDailyGoal = false
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        trendsTypePickers
                    }
                }
            }
        }
        .tint(.ruAccentColor)
    }
    
    private var trendsTypePickers: some View {
        Picker("Choose Type of Data", selection: $trendsDataType.animation(.easeInOut)) {
            ForEach(TrendsDataType.allCases, id: \.self) { dataType in
                Text(dataType.rawValue)
                    .tag(dataType)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 210)
        .padding(.horizontal)
    }
}
