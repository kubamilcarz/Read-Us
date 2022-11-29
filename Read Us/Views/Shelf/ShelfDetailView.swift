//
//  ShelfDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/4/22.
//

import SwiftUI

struct ShelfDetailView: View {
    @Environment(\.presentationMode) var presentionMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataManager: DataManager
    
    var shelf: Shelf
    
    @FetchRequest<Book>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var books: FetchedResults<Book>
    
    
    var filteredBooks: [Book] {
        books.filter { $0.shelvesArray.contains(shelf) }
    }
    
    @State private var isEditModeOn = false
    @State private var isShowingLibraryChoser = false
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var icon = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 25) {
                    if isEditModeOn {
                        ScrollViewReader { scrollView in
                            ScrollView(.horizontal) {
                                HStack(alignment: .center, spacing: 30) {
                                    Rectangle().fill(.clear)
                                        .frame(width: 100)
                                    
                                    ForEach(DataManager.shelfIcons, id: \.self) { sysIcon in
                                        Image(systemName: sysIcon)
                                            .font(.system(size: sysIcon == icon ? 60 : 30).bold())
                                            .foregroundColor(sysIcon == icon ? .ruAccentColor : .secondary)
                                            .id(sysIcon)
                                        
                                            .onTapGesture {
                                                withAnimation {
                                                    icon = sysIcon
                                                }
                                            }
                                    }
                                    
                                    Rectangle().fill(.clear)
                                        .frame(width: 100)
                                }
                                .frame(height: 70)
                                .padding(.vertical)
                            }
                            .onAppear {
                                withAnimation {
                                    scrollView.scrollTo(icon, anchor: .center)
                                }
                            }
                            .onChange(of: icon) { newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        scrollView.scrollTo(newValue, anchor: .center)
                                    }
                                }
                            }
                        }
                    } else {
                        Image(systemName: shelf.icon_string)
                            .font(.system(size: 60).bold())
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .center, spacing: 5) {
                        if isEditModeOn {
                            TextField(shelf.title_string, text: $title)
                                .font(.system(.title, design: .serif))
                                .frame(maxWidth: 240)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField(shelf.subtitle_string, text: $subtitle, axis: .vertical)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: 170)
                                .lineLimit(1...5)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            Text(shelf.title_string)
                                .font(.system(.title, design: .serif))
                                .multilineTextAlignment(.center)
                            
                            if shelf.subtitle_string.isEmpty == false {
                                Text(shelf.subtitle_string)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: 170)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding(30)
                .padding(.bottom, isEditModeOn ? -20 : 0)
                
                BookGrid(books: filteredBooks, isEditModeOn: $isEditModeOn, isShowingLibraryChoser: $isShowingLibraryChoser, shelf: shelf)
                    .padding(.bottom, filteredBooks.count < 5 ? 75 : 0)
                
                if filteredBooks.count >= 5 {
                    VStack(spacing: 5) {
                        Text("Total")
                            .font(.caption)
                            .textCase(.uppercase)
                            .foregroundColor(.secondary)
                        Text("\(filteredBooks.count)")
                            .font(.system(size: 64, design: .serif))
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 75)
        }
        .navigationTitle(shelf.title_string)
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingLibraryChoser) {
            BookChooserSheet(for: shelf)
                .presentationDragIndicator(.visible)
        }
        
        .toolbar {
            Button(isEditModeOn ? "Done" : "Edit") {
                withAnimation {
                    isEditModeOn.toggle()
                }
            }
        }
        
        .onAppear {
            title = shelf.title_string
            subtitle = shelf.subtitle_string
            icon = shelf.icon_string
        }
        
        .onChange(of: isEditModeOn) { _ in
            dataManager.update(shelf: shelf, moc: moc, title: title, subtitle: subtitle, icon: icon)
        }
    }
}
