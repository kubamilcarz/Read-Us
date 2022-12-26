//
//  ReadingNowShelvesSection.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct ReadingNowShelvesSection: View {
    
    var shelves: FetchedResults<Shelf>
    @Binding var isShowingNewShelfSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            sectionHeader
            
            VStack(alignment: .leading, spacing: 5) {
                if shelves.isEmpty {
                    Button {
                        isShowingNewShelfSheet = true
                    } label: {
                        ShelfRow()
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                } else {
                    ForEach(shelves.prefix(3)) { shelf in
                        NavigationLink {
                            ShelfDetailView(shelf: shelf)
                        } label: {
                            ShelfRow(shelf: shelf)
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var sectionHeader: some View {
        HStack {
            Text("Shelves")
                .font(.system(.title2, design: .serif))
                .bold()

            Spacer()
        
            NavigationLink(destination: ShelvesView(isNested: true)) {
                Text("All")
                    .font(.subheadline)
                    .foregroundColor(.ruAccentColor)
            }
        }
    }
}
