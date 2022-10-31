//
//  BookDetailShelvesBar.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

struct BookDetailShelvesBar: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var mainVM: MainViewModel
    
    @FetchRequest<Shelf>(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var shelves: FetchedResults<Shelf>
    
    var book: Book
    
    var body: some View {
        HStack {
            Text("Shelves")
                .font(.system(.headline, design: .serif))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(shelves) { shelf in
                        Text(shelf.safeTitle)
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .foregroundStyle(book.safeShelves.contains(shelf) ? Color.ruAccentColor : .secondary)
                            .background(.secondary.opacity(0.3), in: Capsule())
                            .overlay(book.safeShelves.contains(shelf) ?
                                     Capsule().stroke(Color.ruAccentColor, lineWidth: 1).padding(1)
                                     : nil)
                        
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if book.safeShelves.contains(shelf) {
                                        // remove
                                        book.removeFromShelves(shelf)
                                    } else {
                                        // add
                                        book.addToShelves(shelf)
                                    }
                                    
                                    try? moc.save()
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
