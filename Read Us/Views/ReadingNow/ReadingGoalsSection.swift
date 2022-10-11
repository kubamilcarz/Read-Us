//
//  ReadingGoalsSection.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/7/22.
//

import SwiftUI

struct ReadingGoalsSection: View {
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text("\(Image(systemName: "flame")) Reading Streak")
                    .font(.system(.title2, design: .serif))
                Text("Read every day and finish more books")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 210)
            }
            
            HStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("102")
                        .font(.system(.title, design: .serif))
                        .bold()
                        .foregroundColor(.accentColor)
                    Text("Days in a Row")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack(spacing: 10) {
                    Text("16")
                        .font(.system(.title, design: .serif))
                        .bold()
                        .foregroundColor(.accentColor)
                    Text("Weeks in a Row")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxHeight: 70)
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
    }
}
