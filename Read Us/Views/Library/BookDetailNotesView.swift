//
//  BookDetailNotesView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/19/22.
//

import SwiftUI

struct BookDetailNotesView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var mainVM: MainViewModel
    
    var book: Book
    
    var notes: [Entry] {
        book.safeEntries.filter { $0.safeNotes.isEmpty == false }.sorted(by: { $0.safeDateAdded > $1.safeDateAdded })
    }
    
    @State private var editingNote: Entry?
    @State private var content = ""
    
    @State private var isCreatingNewNote = false
    @State private var isShowingDeleteConfirmation = false
    
    @State private var deletingNote: Entry?
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Notes")
                    .font(.headline)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                if isCreatingNewNote {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(Date.now.formatted())
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        HStack {
                            TextField("What would you like to say?", text: $content, axis: .vertical)
                                .font(.system(.subheadline, design: .serif))
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(1...5)
                                .onSubmit(addNote)
                            
                            Button(action: addNote) {
                                Image(systemName: "arrow.right")
                                    .font(.subheadline)
                            }
                        }
                    }
                } else {
                    newNoteButton
                }
                
                Divider()
                
                ForEach(notes) { note in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(note.safeDateAdded.formatted())
                                .foregroundColor(.secondary)
                                .font(.caption)
                            
                            Group {
                                if editingNote == note {
                                    TextField(note.safeNotes, text: $content, axis: .vertical)
                                        .textFieldStyle(.roundedBorder)
                                        .lineLimit(1...5)
                                        .onSubmit {
                                            note.notes = content
                                            
                                            try? moc.save()
                                            
                                            content = ""
                                            editingNote = nil
                                        }
                                } else {
                                    Text(note.safeNotes)
                                }
                            }
                            .font(.system(.subheadline, design: .serif))
                        }
                        .transition(.scale)
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                if editingNote != note {
                                    editingNote = note
                                    content = note.safeNotes
                                } else {
                                    // save and clear variable
                                    note.notes = content
                                    
                                    try? moc.save()
                                    
                                    content = ""
                                    editingNote = nil
                                }
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.footnote)
                            }
                            
                            Button {
                                deletingNote = note
                                isShowingDeleteConfirmation = true
                            } label: {
                                Image(systemName: "minus.circle")
                                    .font(.footnote)
                            }
                            .tint(.secondary)
                        }
                    }
                    
                }
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let deletingNote {
                    withAnimation {
                        moc.delete(deletingNote)
                        try? moc.save()
                    }
                }
            }
        }
    }
    
    private var newNoteButton: some View {
        Button {
            withAnimation {
                isCreatingNewNote = true
            }
        } label: {
            Label("New Note", systemImage: "plus.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.subheadline)
        }
    }
    
    private func addNote() {
        withAnimation(.easeInOut) {
            let newEntry = Entry(context: moc)
            newEntry.id = UUID()
            newEntry.dateAdded = Date.now
            newEntry.numberOfPages = 0
            newEntry.currentPage = Int16(mainVM.getCurrentPage(for: book))
            newEntry.notes = content.trimmingCharacters(in: .whitespacesAndNewlines)
            newEntry.isVisible = false
            newEntry.book = book
            
            try? moc.save()
            
            content = ""
            isCreatingNewNote = false
        }
    }
}
