//
//  BookieSection.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/31/22.
//

import SwiftUI

struct BookieSection<Content: View>: View {
    var bgColor: SectionColor
    var content: Content
    
    init(_ bgColor: SectionColor, @ViewBuilder content: () -> Content) {
        self.bgColor = bgColor
        self.content = content()
    }
    
    enum SectionColor {
        case ultraThinMaterial, background
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if bgColor == .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .padding(.top, -30)
                
                
                content
                    .padding()
                    .background(.background)
            } else {
                Rectangle()
                    .fill(.background)
                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .padding(.top, -30)
                
                
                content
                    .padding()
                    .background(.ultraThinMaterial)
            }
        }
    }
}
