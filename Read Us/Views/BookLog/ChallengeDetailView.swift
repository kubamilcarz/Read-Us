//
//  ChallengeDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/23/22.
//

import SwiftUI
import FrameUp

struct ChallengeDetailView: View {
    
    var challenge: YearlyChallenge
    
    @FetchRequest<BookReading>(sortDescriptors: []) var readings: FetchedResults<BookReading>
    
    var filteredReadings: [BookReading] {
        readings.filter { $0.dateFinished != nil && $0.dateFinished?.year == challenge.year_int }.sorted { $0.date_finished > $1.date_finished }
    }
    
    @State private var layout: BookLayout = .grid
    @State private var isChallengeUpdateSheetOpen = false
    
    enum BookLayout {
        case list, grid
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        YearlyGoalCell(challenge: challenge)
                        
                        Image(systemName: "pencil.circle")
                            .foregroundColor(.ruAccentColor)
                            .padding()
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        isChallengeUpdateSheetOpen = true
                    }
                    
                    Divider()
                }
                
                HStack {
                    Text("Books")
                        .font(.system(.title2, design: .serif))
                        .bold()
                    
                    Spacer()
                    
                    Picker("Layout", selection: $layout.animation()) {
                        Image(systemName: "list.dash").tag(BookLayout.list)
                        Image(systemName: "rectangle.grid.3x2.fill").tag(BookLayout.grid)
                    }
                    .controlSize(.small)
                    .frame(maxWidth: 120)
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                if layout == .list {
                    VStack {
                        ForEach(filteredReadings) { reading in
                            if let book = reading.book {
                                BookReadingCell(book: book, finishDate: reading.date_finished)
                            }
                        }
                    }
                    .padding(.horizontal)
                } else {
                    WidthReader { width in
                        HFlow(alignment: .center, maxWidth: width, horizontalSpacing: 10, verticalSpacing: 10) {
                            ForEach(filteredReadings) { reading in
                                if let book = reading.book {
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        BookPhotoCell(for: book.cover, minWidth: 50)
                                    }
                                    .frame(minWidth: 50, maxWidth: 50)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding(.bottom, 75)
        }
        .navigationTitle("\(String(challenge.year_int)) Challenge")
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isChallengeUpdateSheetOpen) {
            NewChallengeSheet(challenge: challenge)
        }
    }
}
