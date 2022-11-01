//
//  ShelfRow.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/5/22.
//

import SwiftUI

struct ShelfRow: View {
    var shelf: Shelf?
    
    var body: some View {
        HStack(spacing: 15) {
            if let shelf {
                VStack {
                    Image(systemName: shelf.icon_string)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: 44)
                
                VStack(alignment: .leading) {
                    Text(shelf.title_string)
                        .font(.system(.headline, design: .serif))
                    Text("\(shelf.booksArray.count) book(s)")
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
