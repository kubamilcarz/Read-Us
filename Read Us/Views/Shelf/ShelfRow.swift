//
//  ShelfRow.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/5/22.
//

import SwiftUI

struct ShelfRow: View {
    var shelf: Shelf
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: shelf.safeIcon)
                .font(.title)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading) {
                Text(shelf.safeTitle)
                    .font(.system(.headline, design: .serif))
                Text("\(shelf.safeBooks.count) book(s)")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}
