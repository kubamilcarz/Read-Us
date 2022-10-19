//
//  ShelvesView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/4/22.
//

import SwiftUI

struct ShelvesView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest<Shelf>(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var shelves: FetchedResults<Shelf>

    var isNested: Bool
    
    @State private var isShowingNewShelfSheet = false
    @State private var isShowingAlert = false
    @State private var shelfToDelete: Shelf?

    var content: some View {
        List {
            if shelves.isEmpty {
                Button {
                    isShowingNewShelfSheet = true
                } label: {
                    ShelfRow()
                }
            } else {
                ForEach(shelves) { shelf in
                    NavigationLink(destination: ShelfDetailView(shelf: shelf)) {
                        ShelfRow(shelf: shelf)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete") {
                            shelfToDelete = shelf
                            isShowingAlert = true
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .navigationTitle("Shelves")
        .navigationBarTitleDisplayMode(isNested ? .inline : .automatic)
        .toolbar {
            Button {
                isShowingNewShelfSheet = true
            } label: {
                Label("Add", systemImage: "plus.circle")
            }
            .tint(.secondary)
        }
        
        .sheet(isPresented: $isShowingNewShelfSheet) {
            NewShelfSheet()
                .presentationDetents([.fraction(2/3)])
                .presentationDragIndicator(.visible)
        }
        
        .alert("Are you sure?", isPresented: $isShowingAlert, presenting: shelfToDelete) { _ in
            Button("Cancel", role: .cancel) { }
            
            Button("Remove", role: .destructive) {
                if let shelfToDelete {
                    withAnimation {
                        moc.delete(shelfToDelete)
                        try? moc.save()
                    }
                }
            }
        } message: { _ in
            Text("This action cannot be undone.")
        }

    }
    
    var body: some View {
        if isNested {
            content
        } else {
            NavigationView {
                content
            }
        }
    }
}
