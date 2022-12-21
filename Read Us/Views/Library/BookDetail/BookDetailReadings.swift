//
//  BookDetailReadings.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/30/22.
//

import SwiftUI

struct BookDetailReadings: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataManager: DataManager
    
    var book: Book
    
    @State private var isCurrentlyReading = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Readings")
                    .font(.system(.headline, design: .serif))
                
                Spacer()
                
                HStack {
                    if !isCurrentlyReading {
                        Button("Read Again") {
                            dataManager.startNewRead(moc: moc, for: book)
                            isCurrentlyReading = true
                        }
                    }
                    
                    if book.bookReadingsArray.filter({ $0.dateFinished == nil }).isEmpty {
                        Button("Add") {
                            #warning("Show Sheet with Option to back log your past readings")
                        }
                    }
                }
                .font(.system(size: 10))
                .controlSize(.mini)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 3) {
                ForEach(book.bookReadingsArray.sorted(by: { $0.date_started > $1.date_started })) { reading in
                    NavigationLink {
                        BookReadingDetailView(reading: reading)
                    } label: {
                        BookReadingListCell(reading: reading)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .font(.system(size: 12))
        .buttonStyle(.bordered)
        .controlSize(.mini)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .clipped()
        
        .onAppear {
            isCurrentlyReading = dataManager.getCurrentBookReading(for: book) != nil
        }
    }
}
