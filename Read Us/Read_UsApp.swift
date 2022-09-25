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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
