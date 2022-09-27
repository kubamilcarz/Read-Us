//
//  Read_UsApp.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

@main
struct Read_UsApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
            .withDesign(.serif)!.withSymbolicTraits(.traitBold)!, size: 32)]
        
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).withDesign(.serif)!.withSymbolicTraits(.traitBold)!, size: 16)
        ]
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
