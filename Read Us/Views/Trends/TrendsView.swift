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
                    trendsTypePickers
                    
                    if trendsDataType == .pages {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                                .background(.background)
                                .padding(.top, -30)
                            
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Last 7 Days")
                                        .font(.system(.title2, design: .serif).bold())
                                    
                                    Spacer()
                                }
                                
                                BookChart(for: .week, show: $trendsDataType, withDailyGoal: $withDailyGoal)
                            }
                            .padding()
                            .background(.background)
                        }
                        
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(.background)
                                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .padding(.top, -30)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("This Month")
                                        .font(.system(.title2, design: .serif).bold())
                                    
                                    Spacer()
                                }
                                
                                BookChart(for: .month, show: $trendsDataType, withDailyGoal: $withDailyGoal)
                            }
                            .padding()
                        }
                        
                    }
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(.background)
                            .padding(.top, -30)
                            
                        VStack(alignment: .leading) {
                            HStack {
                                Text("This Year")
                                    .font(.system(.title2, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            BookChart(for: .year, show: $trendsDataType, withDailyGoal: .constant(false))
                        }
                        .padding()
                        .background(.background)
                    }
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.background)
                            .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .padding(.top, -30)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("All")
                                    .font(.system(.title2, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            BookChart(for: .all, show: $trendsDataType, withDailyGoal: .constant(false))
                        }
                        .padding()
                    }
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(.background)
                            .padding(.top, -30)
                    }
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
        }
        .tint(.ruAccentColor)
    }
    
    private var trendsTypePickers: some View {
        HStack {
            
            Picker("Choose Type of Data", selection: $trendsDataType.animation(.easeInOut)) {
                ForEach(TrendsDataType.allCases, id: \.self) { dataType in
                    Text(dataType.rawValue)
                        .tag(dataType)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 210)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}
