//
//  BookPhotoCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct BookPhotoCell: View {
    var photo: UIImage
    var width: CGFloat?
    var minWidth: CGFloat?
    
    init(for photo: UIImage, width: CGFloat = 70) {
        self.photo = photo
        self.width = width
    }
    
    init(for photo: UIImage, minWidth: CGFloat = 70) {
        self.photo = photo
        self.minWidth = minWidth
    }
    
    var cornerRadius: CGFloat {
        if let width {
            return width <= 70 ? 10 : 12
        }
        
        if let minWidth {
            return minWidth <= 70 ? 10 : 12
        }
        
        return 10
    }
    
    var body: some View {
        if let width {
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
        
        if let minWidth {
            Image(uiImage: photo)
                .resizable()
                .aspectRatio(3/5, contentMode: .fill)
                .frame(minWidth: minWidth, minHeight: (minWidth*5)/3)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.secondary)
                )
        }
    }
}

