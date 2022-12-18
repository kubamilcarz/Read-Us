//
//  YearlyGoalCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//

import SwiftUI

struct YearlyGoalCell: View {
    
    var isSetup: Bool
    
    var body: some View {
        VStack {
            if isSetup {
                HStack(alignment: .top, spacing: 15) {
                    bookStack
                    
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("2022 Challenge")
                                    .font(.system(.headline, design: .serif).bold())
                                
                                Spacer()
                            }
                            
                            Text("55/70")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            CustomProgressView(value: 0.4, height: 11)
                        }
                    }
                    
                }
            } else {
                VStack {
                    Text("2023 Challenge")
                        .font(.system(.headline, design: .serif).bold())
                    
                    Button {
                        
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
        YearlyGoalCell(isSetup: true)
    }
}
