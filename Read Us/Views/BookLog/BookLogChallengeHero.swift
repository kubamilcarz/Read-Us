//
//  BookLogChallengeHero.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct BookLogChallengeHero: View {
    @FetchRequest<YearlyChallenge>(sortDescriptors: [SortDescriptor(\.year, order: .reverse)]) var challenges: FetchedResults<YearlyChallenge>
    
    var currentChallenge: YearlyChallenge? {
        challenges.first(where: { $0.year_int == Date.now.year })
    }
    
    var body: some View {
        VStack {
            YearlyGoalCell(challenge: currentChallenge)
            
            HStack {
                SlimYearlyGoalCell()
                
                NavigationLink {
                    PastChallengesView(challenges: challenges)
                } label: {
                    Text("Past Challenges")
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(.primary)
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
