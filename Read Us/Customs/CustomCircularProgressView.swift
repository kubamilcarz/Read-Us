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
                .stroke(.thinMaterial, style: StrokeStyle(lineWidth: borderWidth, lineCap: .round))
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(LinearGradient(colors: [.orange, .ruAccentColor], startPoint: .bottomLeading, endPoint: .topTrailing), style: StrokeStyle(lineWidth: borderWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: width, height: width)
    }
}
