//
//  PastChallengesView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct PastChallengesView: View {
    
    var challenges: FetchedResults<YearlyChallenge>
    
    var currentChallenge: YearlyChallenge? {
        challenges.first(where: { $0.year_int == Date.now.year })
    }
    
    var sortedChallenges: [YearlyChallenge] {
        challenges.sorted { $0.year_int > $1.year_int }.filter { $0.year_int != Date.now.year }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let currentChallenge {
                    YearlyGoalCell(challenge: currentChallenge)
                        .padding(.horizontal)
                    
                    Divider()
                }
                
                VStack {
                    ForEach(sortedChallenges) { challenge in
                        SlimYearlyGoalCell(challenge: challenge)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Past Challenges")
        .navigationBarTitleDisplayMode(.inline)
    }
}

