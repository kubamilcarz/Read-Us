//
//  NewBookSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import PhotosUI
import SwiftUI

struct NewBookSheet: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var pages = ""
    @State private var startedReadingDate = Date.now
    @State private var finishedReadingDate = Date.now
    @State private var notes = ""
    @State private var tags = ""
    @State private var photoSelection: PhotosPickerItem?
    @State private var photo: Image?
    @State private var uiImage: UIImage?
    
    @State private var didFinish = false
    
    var saveImpossible: Bool {
        Int(pages) == nil || title.isEmpty || author.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        HStack(alignment: .top, spacing: 15) {
                            ZStack {
                                if let uiImage {
                                    BookPhotoCell(for: uiImage, width: 100)
                                } else {
                                    Rectangle()
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.8)
                                    
                                    PhotosPicker(selection: $photoSelection) {
                                        Image(systemName: "photo.on.rectangle")
                                            .font(.title)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .aspectRatio(3/5, contentMode: .fill)
                            .frame(width: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.secondary)
                            )
                            
                            VStack(alignment: .leading) {
                                TextField("Title", text: $title)
                                    .textFieldStyle(.roundedBorder)
                                TextField("Author", text: $author)
                                    .textFieldStyle(.roundedBorder)
                                
                                Spacer()
                                
                                HStack {
                                    Text("Page Count")
                                    Spacer()
                                    
                                    TextField("250", text: $pages)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 70)
                                }
                                
                                Spacer()
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(ZStack { })
                        
                    }
                    Section {
                        DatePicker("Start Date", selection: $startedReadingDate, displayedComponents: .date)
                        
                        Toggle(isOn: $didFinish.animation()) {
                            Text("Did you finish?")
                        }
                        if didFinish {
                            DatePicker("Finish Date", selection: $finishedReadingDate, displayedComponents: .date)
                        }
                    }
                    
                    Section {
                        TextField("Tags (comma separated)", text: $tags)
                        
                        TextField("Notes", text: $notes, axis: .vertical)
                            .lineLimit(1...10)
                        
                    }
                }
                
                Button(action: addBook) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .disabled(saveImpossible)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                .tint(.secondary)
            }
            
            .onChange(of: photoSelection) { newValue in
                Task {
                    if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        uiImage = image
                        photo = Image(uiImage: image)
                    }
                }
            }
        }
    }
    
    private func addBook() {
        let newBook = Book(context: moc)
        newBook.id = UUID()
        newBook.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        newBook.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        newBook.numberOfPages = Int16(Int(pages.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
        newBook.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        newBook.startedReadingOn = startedReadingDate
        newBook.isRead = didFinish
        newBook.finishedReadingOn = finishedReadingDate
        newBook.photo = uiImage?.jpegData(compressionQuality: 1.0) ?? Data()
        
        newBook.tags = tags.lowercased().components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        try? moc.save()
        dismiss()
    }
}

struct NewBookSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewBookSheet()
    }
}
