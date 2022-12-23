//
//  BookLogChallengeHero.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct BookLogChallengeHero: View {
    @FetchRequest<YearlyChallenge>(sortDescriptors: []) var challenges: FetchedResults<YearlyChallenge>
    
    var currentChallenge: YearlyChallenge? {
        challenges.first(where: { $0.year_int == Date.now.year })
    }
    
    var previousChallenge: YearlyChallenge? {
        challenges.first(where: { $0.year_int == Date.now.year - 1 })
    }
    
    var body: some View {
        VStack {
            NavigationLink {
                if let currentChallenge {
                    ChallengeDetailView(challenge: currentChallenge)
                }
            } label: {
                YearlyGoalCell(challenge: currentChallenge)
            }
            .buttonStyle(.plain)
            
            HStack {
                if let previousChallenge {
                    SlimYearlyGoalCell(challenge: previousChallenge)
                }
                
                NavigationLink {
                    PastChallengesView(challenges: challenges)
                } label: {
                    Text("Past Challenges")
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundStyle(.primary)
                .padding(10)
                .frame(maxHeight: .infinity)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct BookLogChallengeHero_Previews: PreviewProvider {
    static var previews: some View {
        BookLogChallengeHero()
    }
}
