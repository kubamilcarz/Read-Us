//
//  YearlyGoalCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct YearlyGoalCell: View {
    
    var challenge: YearlyChallenge?
    
    @FetchRequest<BookReading>(sortDescriptors: []) var readings: FetchedResults<BookReading>
    
    var filteredReadings: [BookReading] {
        readings.filter { $0.dateFinished != nil && $0.dateFinished?.year == challenge?.year_int }.sorted { $0.date_finished > $1.date_finished }
    }
    
    var progress: CGFloat {
        CGFloat(filteredReadings.count) / CGFloat(challenge?.goal_int ?? 0)
    }
    
    @State private var isShowingNewChallengeSheet = false
    
    var body: some View {
        VStack {
            if let challenge {
                HStack(alignment: .top, spacing: 15) {
                    bookStack
                    
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("\(String(challenge.year_int)) Challenge")
                                    .font(.system(.headline, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            Text("\(filteredReadings.count)/\(challenge.goal_int)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            CustomProgressView(value: progress, height: 11)
                        }
                    }
                    
                }
            } else {
                VStack {
                    Text("\(String(Date.now.year)) Challenge")
                        .font(.system(.headline, design: .serif).bold())
                    
                    Button {
                        isShowingNewChallengeSheet = true
                    } label: {
                        Text("Set Up")
                            .padding(.horizontal, 30)
                    }
                    .tint(.ruAccentColor)
                    .controlSize(.mini)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                .frame(minHeight: 90)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        
        .sheet(isPresented: $isShowingNewChallengeSheet) {
            NewChallengeSheet(year: String(Date.now.year))
        }
    }
    
    private var bookStack: some View {
        ZStack {
            BookPhotoCell(for: nil, width: 55)
                .padding(.leading, 100)
            BookPhotoCell(for: nil, width: 55)
                .padding(.leading, 50)
            BookPhotoCell(for: nil, width: 55)
        }
        .offset(x: -25)
        .padding(.horizontal, -25)
    }
}

struct YearlyGoalCell_Previews: PreviewProvider {
    static var previews: some View {
        YearlyGoalCell()
    }
}
