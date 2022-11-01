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
    
    var update: BookUpdate
    
    @State private var errorMessage: String?
    @State private var pageCount = ""
    @State private var note = ""
    
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
                    TextField("\(update.number_of_pages)", text: $pageCount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 70)
                }
                
                TextEditor(text: $note)
                    .frame(minHeight: 120, maxHeight: 160)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.secondary)
                            .opacity(0.3)
                            .zIndex(6)
                    )
                    .padding(2)
            }
            
            Button {
                if Int(pageCount) != nil {
                    if Int(pageCount) ?? 0 < 0 {
                        update.numberOfPages = 0
                    } else {
                        update.numberOfPages = Int64(Int(pageCount) ?? 0)
                    }
                    
                    
                    update.note?.content = note.trimmingCharacters(in: .whitespacesAndNewlines)
                    
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
        .navigationTitle(update.date_added.formatted(date: .abbreviated, time: .shortened))
        .onAppear {
            pageCount = String(update.number_of_pages)
            note = update.note?.content_string ?? ""
        }
    }
}
