//
//  ExploreView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI
import SwiftyJSON

struct ExploreView: View {
    @State private var searchQuery = ""
    
    @State private var fetchedBooks = [CachedBook]()
    
    let isbns: [String] = [
        "978-1524763169", "978-0593135204"
    ]
    
    let API_KEY = "###"
    
    var body: some View {
        NavigationStack {
            List(fetchedBooks) { book in
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author.dropLast().dropLast())
                        .foregroundStyle(.secondary)
                    Text(book.isbn10)
                        .font(.caption2)
                }
            }
            .navigationTitle("Explore")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            
            .onAppear(perform: loadData)
        }
    }
    
    private func loadData() {
//        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=+isbn=1524763160&key=\(API_KEY)") else {
//            print("Your API end point is Invalid")
//            return
//        }
//        let request = URLRequest(url: url)
//
        let url = "https://www.googleapis.com/books/v1/volumes?q=jobs&key=\(API_KEY)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            if error != nil {
                print(error?.localizedDescription ?? "some error")
                return
            }
            
            let json = try! JSON(data: data!)
            let items = json["items"].array ?? []
            
            if items.isEmpty == false {
                for i in items {
                    let id = i["id"].stringValue
                    let title = i["volumeInfo"]["title"].stringValue
                    let isbn10 = i["volumeInfo"]["industryIdentifiers"][0]["identifier"].stringValue
                    let isbn13 = i["volumeInfo"]["industryIdentifiers"][1]["identifier"].stringValue
                    
                    let authors = i["volumeInfo"]["authors"].array ?? []
                    var author = ""
                    
                    for j in authors {
                        author += "\(j.stringValue), "
                    }
                    
                    DispatchQueue.main.async {
                        self.fetchedBooks.append(CachedBook(id: id, title: title, author: author, isbn10: isbn10, isbn13: isbn13))
                    }
                }
            }
        }.resume()
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
