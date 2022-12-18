//
//  YearlyGoalCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct YearlyGoalCell: View {
    
    var challenge: YearlyChallenge?
    
    var progress: CGFloat {
        CGFloat(((challenge?.actualNumber_int ?? 0) / (challenge?.goal_int ?? 0)) ?? 0)
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
                                Text("\(challenge.year_int) Challenge")
                                    .font(.system(.headline, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            Text("\(challenge.actualNumber_int)/\(challenge.goal_int)")
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
            Text("hello")
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
