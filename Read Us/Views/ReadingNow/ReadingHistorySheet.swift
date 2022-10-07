//
//  ReadingHistorySheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/5/22.
//

import SwiftUI

struct ReadingHistorySheet: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest<Entry>(sortDescriptors: []) var entries: FetchedResults<Entry>
    
    var body: some View {
        NavigationView {
            List {
                
            }
            .navigationTitle("Reading Log")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
