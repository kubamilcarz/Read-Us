//
//  ReadView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/31/22.
//

import SwiftUI

struct ReadView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Start A New Session") {
                    
                }
                
                Section("Stats") {
                    
                }
                
                Section("Recent Readings") {
                    
                }
            }
            .navigationTitle("Read")
        }
        .accentColor(.ruAccentColor)
    }
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
    }
}
