//
//  CustomProgressView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct CustomProgressView: View {
    var value: CGFloat
    var height: CGFloat
    
    init(value: CGFloat, height: CGFloat = 7) {
        self.value = value
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.thinMaterial)
                    .frame(width: geo.size.width, height: height)
                
                Capsule()
                    .fill(Color.ruAccentColor.gradient)
                    .frame(width: geo.size.width * value, height: height)
            }
        }
        .frame(height: height)
    }
}
