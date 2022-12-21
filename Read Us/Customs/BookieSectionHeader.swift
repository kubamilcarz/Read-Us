//
//  BookieSectionHeader.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct BookieSectionHeader: View {
    
    var title: LocalizedStringKey
    
    init(_ title: LocalizedStringKey) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(.title2, design: .serif).bold())
            
            Spacer()
        }
    }
}
