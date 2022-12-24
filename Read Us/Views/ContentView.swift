//
//  ContentView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject var dataManager = DataManager()
    
    @AppStorage("AppLaunchCount") var launchCount = 0
    
    var body: some View {
        CustomTabBarContainerView(selection: $dataManager.tabSelection) {
            ReadingNowView()
                .tabBarItem(tab: .readingNow, selection: $dataManager.tabSelection)
            LibraryView()
                .tabBarItem(tab: .library, selection: $dataManager.tabSelection)
            TrendsView()
                .tabBarItem(tab: .trends, selection: $dataManager.tabSelection)
            BookLogView()
                .tabBarItem(tab: .bookLog, selection: $dataManager.tabSelection)
        }
        .environmentObject(dataManager)
        .tint(.ruAccentColor)
        .onAppear {
            launchCount += 1
            
            if launchCount % 10 == 0 {
                requestReview()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
