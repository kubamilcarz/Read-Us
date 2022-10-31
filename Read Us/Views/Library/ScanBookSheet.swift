//
//  ScanBookSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/31/22.
//

import CodeScanner
import SwiftyJSON
import SwiftUI

enum ScanStatus {
    case scanning, waitingForResponse, fetching, importing
}

struct ScanBookSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var status: ScanStatus = .scanning
    
    @State private var scannedISBN: String?
    @State private var responseBook = CachedBook(title: "", author: "", isbn10: "", isbn13: "", photo: Data(), numberOfPages: "")
    
    @State private var title = ""
    @State private var author = ""
    
    var body: some View {
        if status == .scanning {
            ZStack(alignment: .topTrailing) {
                CodeScannerView(codeTypes: [.qr, .ean13, .code128], scanMode: .once, showViewfinder: true, simulatedData: "8328716801") { response in
                    if case let .success(result) = response {
                        scannedISBN = result.string
                        analyzeBook(withIdentifer: result.string)
                    } else {
                        print("something went wrong")
                    }
                }
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title3)
                }
                .padding()
            }
        } else {
            ZStack {
                if status == .waitingForResponse {
                    NewBookSheet(for: $responseBook)
                } else {
                    NewBookSheet(for: $responseBook)
                }
                
                if status == .waitingForResponse {
                    Rectangle().fill(.black.opacity(0.3))
                    ProgressView()
                }
            }
            .onAppear {
                if let scannedISBN {
                    getBookDetail(for: scannedISBN)
                }
            }
            .onChange(of: responseBook) { _ in
                if responseBook.author.hasPrefix("/authors/") {
                    responseBook.author = ""
                }
            }
        }
    }
    
    private func analyzeBook(withIdentifer isbn: String) {
        status = .waitingForResponse
    }
    
    private func getBookDetail(for isbn: String) {
        let url = URL(string: "https://openlibrary.org/isbn/\(scannedISBN!).json")!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, error) in
            if error != nil {
                print(error?.localizedDescription ?? "some error")
                return
            }
            
            do {
                let book = try JSON(data: data!)
                if book.isEmpty == false {
                    DispatchQueue.main.async {
                        responseBook.title = book["title"].stringValue
                        responseBook.author = book["authors"][0]["key"].stringValue
                        responseBook.numberOfPages = book["number_of_pages"].stringValue
                        
                        responseBook.isbn10 = book["isbn_10"][0].stringValue
                        responseBook.isbn13 = book["isbn_13"][0].stringValue
                    }
                }
            } catch {
                print("some error")
            }
        }.resume()
        
        getAuthorName(for: responseBook.author)
        getBookCover(for: scannedISBN ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            status = .importing
        }
    }
    
    private func getAuthorName(for urlArg: String) {
        let url = URL(string: "https://openlibrary.org\(urlArg).json")!
                
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, error) in
            if error != nil {
                print(error?.localizedDescription ?? "some error")
                return
            }
            
            let author = try! JSON(data: data!)
            
            DispatchQueue.main.async {
                responseBook.author = author["name"].stringValue
            }
            
        }.resume()
    }
    
    private func getBookCover(for isbn: String) {
        let url = URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg")!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, error) in
            if error != nil {
                print(error?.localizedDescription ?? "some error")
                return
            }

            if let data {
                DispatchQueue.main.async {
                    responseBook.photo = data
                }
            }
            
        }.resume()
    }
}
