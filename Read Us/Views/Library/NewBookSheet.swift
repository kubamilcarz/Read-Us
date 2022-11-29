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
    @EnvironmentObject var dataManager: DataManager
    
    @State private var title: String
    @State private var author: String
    @State private var pages: String
//    @State private var startedReadingDate = Date.now
//    @State private var finishedReadingDate = Date.now
    @State private var notes = ""
    @State private var tags = ""
    @State private var photoSelection: PhotosPickerItem?
    @State private var photo: Image?
    @State private var uiImage: UIImage?
    
//    @State private var didFinish = false
    
    @Binding var cachedBook: CachedBook
    
    init() {
        self._cachedBook = Binding(projectedValue: .constant(CachedBook(title: "", author: "", isbn10: "", isbn13: "", photo: Data(), numberOfPages: "")))
        
        self._title = State(wrappedValue: "")
        self._author = State(wrappedValue: "")
        self._pages = State(wrappedValue: "")
    }
    
    init(for cachedBook: Binding<CachedBook>) {
        self._cachedBook = Binding(projectedValue: cachedBook)
        
        self._title = State(wrappedValue: cachedBook.title.wrappedValue)
        self._author = State(wrappedValue: cachedBook.author.wrappedValue)
        self._pages = State(wrappedValue: cachedBook.numberOfPages.wrappedValue)
        self._uiImage = State(wrappedValue: UIImage(data: cachedBook.photo.wrappedValue))
    }
    
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
                                }
                                
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.3)
                                
                                PhotosPicker(selection: $photoSelection) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.title)
                                        .foregroundColor(.primary)
                                }
                                
                            
                            }
                            .aspectRatio(3/5, contentMode: .fill)
                            .frame(width: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.secondary)
                                    .padding(1)
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
//                    Section {
//                        DatePicker("Start Date", selection: $startedReadingDate, in: ...Date.now, displayedComponents: .date)
//
//                        Toggle(isOn: $didFinish.animation()) {
//                            Text("Did you finish?")
//                        }
//                        if didFinish {
//                            DatePicker("Finish Date", selection: $finishedReadingDate, in: startedReadingDate..., displayedComponents: .date)
//                        }
//                    }
                    
                    Section {
                        TextField("Tags (comma separated)", text: $tags)
                        
                        TextField("Notes", text: $notes, axis: .vertical)
                            .lineLimit(1...10)
                        
                    }
                }
                .onSubmit {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                Button("Done") {
                    dismiss()
                }
            }
            
            .onChange(of: photoSelection) { newValue in
                Task {
                    if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        uiImage = image
                        photo = Image(uiImage: image)
                    }
                }
            }
            
            .onChange(of: cachedBook, perform: { _ in
                title = cachedBook.title
                author = cachedBook.author
                pages = cachedBook.numberOfPages
                uiImage = UIImage(data: cachedBook.photo)
            })
            
//            .onChange(of: startedReadingDate) { newValue in
//                finishedReadingDate = newValue + 604_800
//            }
        }
    }
    
    private func addBook() {
        let newBook = Book(context: moc)
        newBook.id = UUID()
        newBook.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        newBook.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        newBook.numberOfPages = Int64(Int(pages.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
        newBook.cover = uiImage?.jpegData(compressionQuality: 1.0) ?? Data()
        
//        if !didFinish {
//            dataManager.startNewRead(moc: moc, for: newBook)
//        }
        
//        newBook.isRead = didFinish
//        newBook.isReading = !didFinish
        
        // TODO: Add Tags
        
        try? moc.save()
        dismiss()
    }
}
