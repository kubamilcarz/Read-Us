//
//  DataRemovalView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/5/22.
//
//  View is Nested in NavigationView
//

import SwiftUI

struct DataRemovalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var isRemovalAllowed = false
    @State private var isShowingConfirmation = false
    
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    @FetchRequest(sortDescriptors: []) var bookUpdates: FetchedResults<BookUpdate>
    @FetchRequest(sortDescriptors: []) var bookReadings: FetchedResults<BookReading>
    @FetchRequest(sortDescriptors: []) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: []) var quotes: FetchedResults<Quote>
    @FetchRequest(sortDescriptors: []) var tags: FetchedResults<Tag>
    @FetchRequest(sortDescriptors: []) var sessions: FetchedResults<Session>
    @FetchRequest(sortDescriptors: []) var shelves: FetchedResults<Shelf>
    
    var body: some View {
        List {
            Section {
                Toggle("Are you sure?", isOn: $isRemovalAllowed.animation())
                
                if isRemovalAllowed {
                    Button(role: .destructive) {
                        isShowingConfirmation = true
                    } label: {
                        Label("Remove All Data", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .padding(7)
                    }
                }
            } footer: {
                Text("This operation cannot be undone.")
            }
        }
        .navigationTitle("Data Removal")
        .navigationBarTitleDisplayMode(.inline)
        
        .confirmationDialog("Are you sure you want to remove all data? \("This operation cannot be undone.")", isPresented: $isShowingConfirmation, titleVisibility: .visible) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                Task {
                    await removeAllData()
                }
            }
        }
    }
    
    private func removeAllData() async {
        for book in books {
            moc.delete(book)
        }
        try? moc.save()
        
        for update in bookUpdates {
            moc.delete(update)
        }
        try? moc.save()
        
        for reading in bookReadings {
            moc.delete(reading)
        }
        try? moc.save()
        
        for note in notes {
            moc.delete(note)
        }
        try? moc.save()
        
        for quote in quotes {
            moc.delete(quote)
        }
        try? moc.save()
        
        for tag in tags {
            moc.delete(tag)
        }
        try? moc.save()
        
        for session in sessions {
            moc.delete(session)
        }
        try? moc.save()
        
        for shelf in shelves {
            moc.delete(shelf)
        }
        try? moc.save()
        
        dismiss()
    }
}

struct DataRemovalView_Previews: PreviewProvider {
    static var previews: some View {
        DataRemovalView()
    }
}
