//
//  ReadingGoalsSection.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/7/22.
//

import SwiftUI

struct ReadingGoalsSection: View {
    
    @FetchRequest<BookUpdate>(sortDescriptors: [
        SortDescriptor(\.dateAdded)
    ]) var updates: FetchedResults<BookUpdate>
    
    var display: DisplayType
    
    init(for display: DisplayType) {
        self.display = display
    }
    
    enum DisplayType {
        case readingNow, today
    }
    
    private var readingStreakInDays: Int {
//        var days: [Date] = []
        var longestStreak = 0
        let twentyFourInSeconds = 86400.0
        
        var lastIteratingUpdate: Date = updates.first?.date_added ?? Date.now.midnight
        
        for update in updates {
            let currentIteratingUpdate = update.date_added.midnight
            
            if currentIteratingUpdate.timeIntervalSince(lastIteratingUpdate) == twentyFourInSeconds {
                longestStreak += 1
            }

            lastIteratingUpdate = currentIteratingUpdate
        }
        
        return longestStreak
    }
    
    var body: some View {
        VStack(spacing: display == .readingNow ? 15 : 30) {
            VStack(spacing: 5) {
                if display == .readingNow {
                    HStack(spacing: 5) {
                        Image(systemName: "flame")
                            .bold()
                        
                        Text("Reading Streak")
                    }
                    .font(.system(.title2, design: .serif))
                    .bold()
                    
                    Text("Read every day and finish more books")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 210)
                } else if display == .today {
                    HStack {
                        Text("Reading Streak")
                            .font(.system(.title2, design: .serif))
                            .bold()
                        
                        Spacer()
                    }
                }
            }
            
            HStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("\(readingStreakInDays)")
                        .font(.system(.title, design: .serif))
                        .bold()
                        .foregroundColor(.ruAccentColor)
                    Text("Days in a Row")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
//                Divider()
//                
//                VStack(spacing: 10) {
//                    Text("0")
//                        .font(.system(.title, design: .serif))
//                        .bold()
//                        .foregroundColor(.ruAccentColor)
//                    Text("Weeks in a Row")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
            }
            .frame(maxHeight: 70)
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
    }
}
