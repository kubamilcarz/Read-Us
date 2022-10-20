//
//  CustomCircularProgressView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/6/22.
//

import SwiftUI

struct CustomCircularProgressView: View {
    
    var borderWidth: CGFloat
    var width: CGFloat
    var progress: CGFloat
    
    init(progress: CGFloat, width: CGFloat, borderWidth: CGFloat = 2) {
        self.borderWidth = borderWidth
        self.width = width
        self.progress = progress
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .strokeBorder(.secondary, lineWidth: borderWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(lineWidth: borderWidth)
                .rotationEffect(.degrees(-90))
                .foregroundColor(Color.ruAccentColor)
                .frame(width: width, height: width)
        }
        .padding(width > 30 ? 15 : 0)
        .frame(width: width, height: width)
    }
}
