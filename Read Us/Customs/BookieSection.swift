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
        case even, odd
    }
    
    var body: some View {
        Group {
            if bgColor == .even {
                content
                    .padding()
                    .background(.background)
            } else {
                content
                    .padding()
                    .background(.ultraThinMaterial)
            }
        }
    }
}
