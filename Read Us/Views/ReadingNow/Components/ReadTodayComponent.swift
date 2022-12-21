//
//  ReadTodayComponent.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct ReadTodayComponent: View {
    
    @FetchRequest<BookUpdate>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var updates: FetchedResults<BookUpdate>
    
    @AppStorage("dailyGoal") var dailyGoal = 20
    
    @State private var isShowingReadingLogSheet = false
    
    var filteredEntries: [BookUpdate] {
        updates.filter { $0.date_added.midnight == Date().midnight && $0.isVisible }
    }
    
    var numberOfPagesReadToday: Int {
        var number = 0
        _ = filteredEntries.map { number += $0.number_of_pages }
        
        return number
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                CustomCircularProgressView(progress: CGFloat(numberOfPagesReadToday) / CGFloat(dailyGoal), width: 13)
                
                Text("Today's Reading")
                    .foregroundColor(.ruAccentColor)
                    .font(.system(size: 12, weight: .semibold))
                
                Text("\(numberOfPagesReadToday)/\(dailyGoal) pages")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .onTapGesture {
                isShowingReadingLogSheet = true
            }
            .padding(.horizontal)
            
            Divider()
        }
        .sheet(isPresented: $isShowingReadingLogSheet) {
            TodaysReadingSheet()
                .presentationDragIndicator(.visible)
        }
    }
}

struct ReadTodayComponent_Previews: PreviewProvider {
    static var previews: some View {
        ReadTodayComponent()
    }
}
