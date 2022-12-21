//
//  ReadingNowView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

struct ReadingNowView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest<Shelf>(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var shelves: FetchedResults<Shelf>
    
    @State private var isShowingReadingHistorySheet = false
    @State private var isShowingSettingsSheet = false
    @State private var isShowingNewShelfSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ReadTodayComponent()
                        
                    CurrentlyReadingHorizontalList(
                        shelves: shelves,
                        isShowingNewShelfSheet: $isShowingNewShelfSheet)
                    
                    Divider()
                    
                    ReadingNowShelvesSection(
                        shelves: shelves,
                        isShowingNewShelfSheet: $isShowingNewShelfSheet)
                        .padding(.horizontal)
                    
                    Divider()
                    
                    ReadingGoalsSection(for: .readingNow)
                        .padding(.horizontal)
                    
                    Divider()
                    
                    BookLogChallengeHero()
                        .padding(.horizontal)
                    
                    Divider()
                    
                    ReadThisYearSection(for: Date.now.year)
                        .padding(.horizontal)
                }
                .padding(.bottom, 75)
            }
            .navigationTitle("Reading Now")
            
            .sheet(isPresented: $isShowingSettingsSheet) {
                SettingsSheet()
            }
            .sheet(isPresented: $isShowingNewShelfSheet) {
                NewShelfSheet()
                    .presentationDetents([.fraction(2/3)])
                    .presentationDragIndicator(.visible)
            }
            
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
                    .presentationDragIndicator(.visible)
            }
            
            .toolbar {
                profileButton
            }
        }
        .tint(.ruAccentColor)
    }
    
    private var profileButton: some View {
        Button {
            isShowingSettingsSheet = true
        } label: {
            Label("Profile", systemImage: "person.circle")
        }
    }
}
