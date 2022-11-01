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
    
    var notes: [Note] {
        book.notesArray.filter { $0.content_string.isEmpty == false }.sorted(by: { $0.date_added > $1.date_added })
    }
    
    @State private var editingNote: Note?
    @State private var content = ""
    
    @State private var isCreatingNewNote = false
    @State private var isShowingDeleteConfirmation = false
    
    @State private var deletingNote: Note?
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Notes")
                    .font(.system(.headline, design: .serif))
                
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
               
                if !notes.isEmpty { Divider() } else { HStack { Spacer() } }
                
                ForEach(notes) { note in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(note.date_added.formatted())
                                .foregroundColor(.secondary)
                                .font(.caption)
                            
                            Group {
                                if editingNote == note {
                                    TextField(note.content_string, text: $content, axis: .vertical)
                                        .textFieldStyle(.roundedBorder)
                                        .lineLimit(1...5)
                                        .onSubmit {
                                            note.content = content
                                            
                                            try? moc.save()
                                            
                                            content = ""
                                            editingNote = nil
                                        }
                                } else {
                                    Text(note.content_string)
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
                                    content = note.content_string
                                } else {
                                    // save and clear variable
                                    note.content = content
                                    
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
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        
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
            let newNote = Note(context: moc)
            newNote.id = UUID()
            newNote.dateAdded = Date.now
            newNote.pageNumber = Int64(mainVM.getCurrentPage(for: book))
            newNote.content = content.trimmingCharacters(in: .whitespacesAndNewlines)

            newNote.book = book
            
            try? moc.save()
            
            content = ""
            isCreatingNewNote = false
        }
    }
}
