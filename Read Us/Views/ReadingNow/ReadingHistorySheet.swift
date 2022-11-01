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
    
    var isSheet: Bool = true
    
    @FetchRequest<BookUpdate>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var updates: FetchedResults<BookUpdate>
    
    var filteredEntries: [Date: [BookUpdate]] {
        var result: [Date: [BookUpdate]] = [:]
        
        if updates.isEmpty { return result }
                
        var currentMidnight = updates[0].date_added.midnight
        
        for update in updates {
            if result[currentMidnight] == nil {
                result[currentMidnight] = []
            }
            
            if update.date_added.midnight == currentMidnight {
                result[currentMidnight]!.append(update)
            } else {
                currentMidnight = update.date_added.midnight
            }
        }
        
        return result
    }
    
    @AppStorage("HidingExcludedEntriesToggle") private var isHidingExcluded = false
    
    var body: some View {
        NavigationView {
            List {
                if filteredEntries.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "tray")
                            .font(.system(size: 44))
                        
                        Text("No Reading Log")
                            .font(.system(.headline, design: .serif))
                        
                        HStack { Spacer() }
                    }
                    .foregroundColor(.secondary)
                    .padding()
                } else {
                    ForEach(filteredEntries.sorted(by: { $0.key > $1.key }), id: \.key) { key, value in
                        if isHidingExcluded && value.filter { $0.isVisible }.isEmpty {
                            Text("")
                        } else {
                            Section {
                                ForEach(value, id: \.self) { update in
                                    if isHidingExcluded && update.isVisible == false {
                                    } else {
                                        NavigationLink {
                                            EditReadingEntryView(update: update)
                                        } label: {
                                            logRow(update: update)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            } header: {
                                HStack {
                                    Text("\(key.formatted(date: .long, time: .omitted))")
                                    Spacer()
                                    Text("\(getTotalNumberOfPages(for: value))")
                                        .bold()
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(isSheet ? .visible : .hidden)
            
            .navigationTitle("Reading Log")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(!isSheet)

            .toolbar {
                if isSheet {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            
            .toolbar {
                if isSheet {
                    ToolbarItem(placement: isSheet ? .navigationBarLeading : .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                isHidingExcluded.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        .padding(0)
                        .font(.subheadline)
                        .buttonStyle(.bordered)
                        .clipShape(Circle())
                        .tint(isHidingExcluded ? .ruAccentColor : .secondary)
                    }
                }
            }
        }
    }
    
    private func logRow(update: BookUpdate) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(update.date_added.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                Text(update.book?.title_string ?? "Unknown Book")
                    .foregroundColor(.secondary)
                    .font(.system(.caption, design: .serif))
            }
            Spacer()
            Text("**\(update.number_of_pages)** page(s)")
                .font(.caption)
                .bold()
        }
        .opacity(update.isVisible ? 1 : 0.3)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                update.isVisible.toggle()
                try? moc.save()
            } label: {
                Label("Exclude", systemImage: "square.3.stack.3d.slash")
            }
            .tint(.ruAccentColor)
            
            Button {
                moc.delete(update)
                try? moc.save()
            } label: {
                Label("Remove", systemImage: "minus.circle")
            }
            .tint(.red)
        }
    }
    
    private func getTotalNumberOfPages(for updates: [BookUpdate]) -> Int {
        var result = 0
        
        for update in updates.filter({ $0.isVisible }) {
            result += update.number_of_pages
        }
        
        return result
    }
}
