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
                VStack(spacing: 0) {
//                    trendsTypePickers
                    
                    if trendsDataType == .pages {
                        BookieSection(.background) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Last 7 Days")
                                        .font(.system(.title2, design: .serif).bold())
                                    
                                    Spacer()
                                }
                                
                                BookChart(for: .week, show: $trendsDataType, withDailyGoal: $withDailyGoal)
                                    .frame(minHeight: 250)
                            }
                        }
                        
                        BookieSection(.ultraThinMaterial) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("This Month")
                                        .font(.system(.title2, design: .serif).bold())
                                    
                                    Spacer()
                                }
                                
                                BookChart(for: .month, show: $trendsDataType, withDailyGoal: $withDailyGoal)
                                    .frame(minHeight: 250)
                            }
                        }
                    }
                    
                    BookieSection(.background) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("This Year")
                                    .font(.system(.title2, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            BookChart(for: .year, show: $trendsDataType, withDailyGoal: .constant(false))
                                .frame(minHeight: 250)
                        }
                    }
                    
                    BookieSection(.ultraThinMaterial) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("All")
                                    .font(.system(.title2, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            BookChart(for: .all, show: $trendsDataType, withDailyGoal: .constant(false))
                        }
                    }
                    
                    BookieSection(.background) { }
                }
                .padding(.bottom, 75)
            }
            .background(.ultraThinMaterial)
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
