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
    
    @FetchRequest<Entry>(sortDescriptors: [
        SortDescriptor(\.dateAdded, order: .reverse)
    ]) var entries: FetchedResults<Entry>
    
    var filteredEntries: [Date: [Entry]] {
        var result: [Date: [Entry]] = [:]
        
        if entries.isEmpty { return result }
                
        var currentMidnight = entries[0].safeDateAdded.midnight
        
        for entry in entries {
            if result[currentMidnight] == nil {
                result[currentMidnight] = []
            }
            
            if entry.safeDateAdded.midnight == currentMidnight {
                result[currentMidnight]!.append(entry)
            } else {
                currentMidnight = entry.safeDateAdded.midnight
            }
        }
        
        return result
    }
    
    @AppStorage("HidingExcludedEntriesToggle") private var isHidingExcluded = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredEntries.sorted(by: { $0.key > $1.key }), id: \.key) { key, value in
                    if isHidingExcluded && value.filter { $0.isVisible }.isEmpty {
                        
                    } else {
                        Section {
                            ForEach(value, id: \.self) { entry in
                                if isHidingExcluded && entry.isVisible == false {
                                } else {
                                    NavigationLink {
                                        EditReadingEntryView(entry: entry)
                                    } label: {
                                        logRow(entry: entry)
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
            .navigationTitle("Reading Log")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
    
    private func logRow(entry: Entry) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.safeDateAdded.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                Text(entry.book?.safeTitle ?? "Unknown Book")
                    .foregroundColor(.secondary)
                    .font(.system(.caption, design: .serif))
            }
            Spacer()
            Text("**\(entry.safeNumerOfPagesRead)** page(s)")
                .font(.caption)
                .bold()
        }
        .opacity(entry.isVisible ? 1 : 0.3)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                entry.isVisible.toggle()
                try? moc.save()
            } label: {
                Label("Exclude", systemImage: "square.3.stack.3d.slash")
            }
            .tint(.ruAccentColor)
            
            Button {
                moc.delete(entry)
                try? moc.save()
            } label: {
                Label("Remove", systemImage: "minus.circle")
            }
            .tint(.red)
        }
    }
    
    private func getTotalNumberOfPages(for entries: [Entry]) -> Int {
        var result = 0
        
        for entry in entries.filter { $0.isVisible } {
            result += entry.safeNumerOfPagesRead
        }
        
        return result
    }
}
