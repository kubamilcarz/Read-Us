//
//  EditReadingEntryView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/17/22.
//

import SwiftUI

struct EditReadingEntryView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var entry: Entry
    
    @State private var errorMessage: String?
    @State private var pageCount = ""
    
    var body: some View {
        List {
            if let errorMessage {
                VStack {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .withoutListInset()
                .listRowBackground( Rectangle().fill(.clear) )
            }
            
            Section {
                HStack {
                    Text("Number of pages")
                    Spacer()
                    TextField("\(entry.safeNumerOfPagesRead)", text: $pageCount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 70)
                }
            }
            
            Button {
                if Int(pageCount) != nil {
                    if Int(pageCount) ?? 0 < 0 {
                        entry.numberOfPages = 0
                    } else {
                        entry.numberOfPages = Int16(Int(pageCount) ?? 0)
                    }
                    
                    try? moc.save()
                    
                    dismiss()
                } else {
                    withAnimation {
                        errorMessage = String(localized: "Typed value is not a number")
                    }
                }
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding(7)
            }
            .buttonStyle(.borderedProminent)
            .tint(.ruAccentColor)
            .withoutListInset()
        }
        .navigationTitle(entry.safeDateAdded.formatted(date: .abbreviated, time: .shortened))
        .onAppear {
            pageCount = String(entry.safeNumerOfPagesRead)
        }
    }
}
