//
//  BookLogView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/31/22.
//

import SwiftUI

struct BookLogView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    BookLogChallengeHero()
                        .padding(.horizontal)
                    
                    Divider()
                    
                    BookLogRecentlyReadCell()
                        .padding(.horizontal)
                }
                .padding(.bottom, 75)
            }
            .navigationTitle("Book Log")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .accentColor(.ruAccentColor)
    }
    
    private func bookCell(reading: BookReading) -> some View {
        VStack(alignment: .leading) {
            if let book = reading.book {
                HStack(alignment: .top) {
                    BookPhotoCell(for: book.cover, width: 44)
                    
                    VStack(alignment: .leading) {
                        Text(reading.date_finished.formatted(date: .abbreviated, time: .shortened))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text(book.title_string)
                            .font(.system(.headline, design: .serif))
                        Text(book.author_string)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            } else {
                Text("unknown book")
            }
        }
    }
}

struct BookLogView_Previews: PreviewProvider {
    static var previews: some View {
        BookLogView()
    }
}
