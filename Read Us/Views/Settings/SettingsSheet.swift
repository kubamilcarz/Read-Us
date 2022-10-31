//
//  SettingsSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/31/22.
//

import SwiftUI

struct SettingsSheet: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: { }) {
                        Label("Notifications", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: { }) {
                        Label("Manage Shelves", systemImage: "books.vertical")
                    }
                }
                
                NavigationLink(destination: { }) {
                    Label("Delete Data", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
