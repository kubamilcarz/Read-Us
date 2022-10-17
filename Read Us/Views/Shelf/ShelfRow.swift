//
//  ShelfRow.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/5/22.
//

import SwiftUI

struct ShelfRow: View {
    var shelf: Shelf?
    
    init(shelf: Shelf) {
        self.shelf = shelf
    }
    
    init() {
        
    }
    
    var body: some View {
        HStack(spacing: 15) {
            if let shelf {
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
            } else {
                Image(systemName: "photo.on.rectangle")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .redacted(reason: .placeholder)
                
                VStack(alignment: .leading) {
                    Text("New Shelf")
                        .foregroundColor(.secondary)
                }
                
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}
