//
//  SlimYearlyGoalCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct SlimYearlyGoalCell: View {
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("2021 Challenge")
                            .font(.system(.subheadline, design: .serif).bold())
                        
                        Spacer()
                    }
                    
                    Text("31 books")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            bookStack
            
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var bookStack: some View {
        ZStack {
            BookPhotoCell(for: nil, width: 25)
            BookPhotoCell(for: nil, width: 25)
                .padding(.leading, 30)
            BookPhotoCell(for: nil, width: 25)
                .padding(.leading, 60)
            
            Text("+28")
                .font(.caption2)
                .foregroundColor(.secondary)
                .aspectRatio(3/5, contentMode: .fill)
                .frame(width: 25, height: (25*5)/3)
                .background(.background, in: RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.secondary)
                )
                .padding(.leading, 90)
        }
        .offset(x: -22.5)
        .padding(.horizontal, -22.5)
    }
}

struct SlimYearlyGoalCell_Previews: PreviewProvider {
    static var previews: some View {
        SlimYearlyGoalCell()
    }
}
