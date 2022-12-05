//
//  BackupView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/5/22.
//
//  Nested in NavigationView

import SwiftUI

struct BackupView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest<Book>(sortDescriptors: [SortDescriptor(\.dateAdded)]) var books: FetchedResults<Book>
    
    @State private var isExporting = false
    @State private var isImporting = false
    @State private var isMergingOn = false
    
    @State private var document = TextFile(initialText: "")
    
    @State private var isShowingMessage = false
    @State private var message: LocalizedStringKey = ""
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Button {
                        updateDocument()
                        isExporting = true
                    } label: {
                        Label("Export Backup", systemImage: "square.and.arrow.up")
                    }
                } footer: {
                    Text("Make a backup of current data and export it as a JSON file.")
                }
                
                Section {
                    Toggle("Merge with Library", isOn: $isMergingOn)
                    
                    Button {
                        isImporting = true
                    } label: {
                        Label("Import Backup", systemImage: "square.and.arrow.down")
                    }
                } footer: {
                    Text("Import a backup in JSON format. You can choose if you want it to replace or merge with current library.")
                }
            }
            
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 15) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 60))
                    Text(message)
                        .font(.title)
                }
                .padding(30)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            
            .opacity(isShowingMessage ? 1 : 0)
            .onChange(of: isShowingMessage) { _ in
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        withAnimation {
                            isShowingMessage = false
                            dismiss()
                        }
                    }
                }
            }
            
        }
        .navigationTitle("Backup")
        .navigationBarTitleDisplayMode(.inline)
        
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.plainText], allowsMultipleSelection: false) { result in
            importBooks(result)
        }
        
        .fileExporter(isPresented: $isExporting, document: document, contentType: .plainText) { result in
            print(result)
            message = "Success!"
            isShowingMessage = true
        }
    }
    
    func updateDocument() {
        var cachedBooks = [BackupBook]()
        
        for book in books {
            let cached = BackupBook(
                title: book.title_string,
                author: book.author_string,
                cover: book.cover ?? Data(),
                numberOfPages: book.number_of_pages,
                dateAdded: book.date_added
            )
            
            cachedBooks.append(cached)
        }
        
        do {
            let json = try JSONEncoder().encode(cachedBooks)
            let textJSON = String(decoding: json, as: UTF8.self)

            self.document = TextFile(initialText: textJSON)
        } catch {
            self.document = TextFile(initialText: "")
        }
    }
    
    func importBooks(_ result: Result<[URL], Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            let _ = selectedFile.startAccessingSecurityScopedResource()

            if let fileContent = try? Data(contentsOf: selectedFile) {
                if let decodedResponse = try? JSONDecoder().decode([BackupBook].self, from: fileContent) {
                    
                    if isMergingOn == false {
                        // if it's turned off, replace whole library with new ones
                        for book in books {
                            moc.delete(book)
                        }
                        
                        try? moc.save()
                    }
                    
                    for item in decodedResponse {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = item.title
                        newBook.author = item.author
                        newBook.cover = item.cover
                        newBook.dateAdded = item.dateAdded
                        newBook.numberOfPages = Int64(item.numberOfPages)
                        
                        try? moc.save()
                    }
                }
            }
            
            let _ = selectedFile.stopAccessingSecurityScopedResource()
            
        } catch(let error) {
            print(error)
        }
        
        message = "Success!"
        isShowingMessage = true
    }
}

struct BackupView_Previews: PreviewProvider {
    static var previews: some View {
        BackupView()
    }
}
