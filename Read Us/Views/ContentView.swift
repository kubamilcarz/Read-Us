//
//  ContentView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI
import CoreData

struct ContentView: View {    
    @StateObject var dataManager = DataManager()
    
    var body: some View {
        CustomTabBarContainerView(selection: $dataManager.tabSelection) {
            ReadingNowView()
                .tabBarItem(tab: .readingNow, selection: $dataManager.tabSelection)
            LibraryView()
                .tabBarItem(tab: .library, selection: $dataManager.tabSelection)
            TrendsView()
                .tabBarItem(tab: .trends, selection: $dataManager.tabSelection)
            ReadView()
                .tabBarItem(tab: .read, selection: $dataManager.tabSelection)
        }
        .environmentObject(dataManager)
        .tint(.ruAccentColor)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
