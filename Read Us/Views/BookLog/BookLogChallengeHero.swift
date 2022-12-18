//
//  BookLogChallengeHero.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct BookLogChallengeHero: View {
    var body: some View {
        VStack {
            YearlyGoalCell(isSetup: true)
            
            HStack {
                SlimYearlyGoalCell()
                
                NavigationLink {
                    Text("")
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
