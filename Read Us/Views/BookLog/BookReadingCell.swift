//
//  BookReadingCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct BookReadingCell: View {
    
    var book: Book
    var finishDate: Date
    var readingID: UUID?
    
    @Namespace private var bookCoverAnimation
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            BookPhotoCell(for: book.cover, width: 65)
                .matchedGeometryEffect(id: "bookCover-\(readingID?.uuidString ?? UUID().uuidString)", in: bookCoverAnimation)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(book.title_string)
                        .font(.system(.subheadline, design: .serif))
                        .bold()
                    Text(book.author_string)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack {
                    Text("Finished on \(finishDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.vertical, 10)
        }
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
    }
}
