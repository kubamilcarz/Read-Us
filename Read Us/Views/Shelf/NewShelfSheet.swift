//
//  NewShelfSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/5/22.
//

import SwiftUI

struct NewShelfSheet: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var chosenIcon = "book"
    @State private var title = ""
    @State private var subtitle = ""
    
    @FocusState private var isFocusedTitle: Bool
    
    var body: some View {
        NavigationView {
            List {
                TextField("Title", text: $title)
                    .focused($isFocusedTitle)
                TextField("Description", text: $subtitle, axis: .vertical)
                    .lineLimit(1...5)
                
                Section {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 15) {
                            ForEach(DataManager.shelfIcons, id: \.self) { icon in
                                Button {
                                    chosenIcon = icon
                                } label: {
                                    Text("\(Image(systemName: icon))")
                                        .font(.headline)
                                        .padding(5)
                                }
                                .buttonStyle(.bordered)
                                .tint(icon == chosenIcon ? .ruAccentColor : .secondary)
                                .clipShape(Circle())
                                .frame(minWidth: 70, minHeight: 70)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1/1, contentMode: .fit)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                
                Button(action: saveShelf) {
                    Text("Add Shelf")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .withoutListInset()
            }
            .navigationTitle("New Shelf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            
            .onAppear {
                isFocusedTitle = true
            }
        }
    }
    
    private func saveShelf() {
        dataManager.add(shelf: Shelf(context: moc), moc: moc, title: title, subtitle: subtitle, icon: chosenIcon)
        
        dismiss()
    }
}
