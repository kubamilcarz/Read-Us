//
//  ContentView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI
import CoreData

struct ContentView: View {    
    @StateObject var mainVM = MainViewModel()
    
    var body: some View {
        CustomTabBarContainerView(selection: $mainVM.tabSelection) {
            ReadingNowView()
                .tabBarItem(tab: .readingNow, selection: $mainVM.tabSelection)
            LibraryView()
                .tabBarItem(tab: .library, selection: $mainVM.tabSelection)
            ExploreView()
                .tabBarItem(tab: .explore, selection: $mainVM.tabSelection)
            ProfileView()
                .tabBarItem(tab: .profile, selection: $mainVM.tabSelection)
        }
        .environmentObject(mainVM)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
