//
//  BookPhotoCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct BookPhotoCell: View {
    var photo: UIImage
    var width: CGFloat
    
    init(for photo: UIImage, width: CGFloat = 70) {
        self.photo = photo
        self.width = width
    }
    
    var cornerRadius: CGFloat {
        width <= 70 ? 10 : 12
    }
    
    var body: some View {
        Image(uiImage: photo)
            .resizable()
            .aspectRatio(3/5, contentMode: .fill)
            .frame(width: width, height: (width*5)/3)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.secondary)
            )
    }
}

