//
//  BookPhotoCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct BookPhotoCell: View {
    var photoData: Data?
    var photo: UIImage?
    var width: CGFloat?
    var minWidth: CGFloat?
    
    init(for photo: Data?, width: CGFloat = 70) {
        self.photoData = photo
        self.width = width
    }
    
    init(for photo: UIImage, width: CGFloat = 70) {
        self.photo = photo
        self.width = width
    }
    
    init(for photo: Data?, minWidth: CGFloat = 70) {
        self.photoData = photo
        self.minWidth = minWidth
    }
    
    var cornerRadius: CGFloat {
        if let width {
            if width <= 70 && width >= 50 {
                return 10
            } else if width < 50 {
                return 6
            } else {
                return 12
            }
        }
        
        if let minWidth {
            return minWidth <= 70 ? 10 : 12
        }
        
        return 10
    }
    
    var readyImage: some View {
        Group {
            if let photo {
                Image(uiImage: photo)
            } else {
                if UIImage(data: photoData ?? Data()) != nil {
                    Image(uiImage: UIImage(data: photoData ?? Data())!).resizable()
                } else {
                    ZStack {
                        Rectangle().fill(.ultraThinMaterial)
                        if let width {
                            Image(systemName: "photo.on.rectangle")
                                .font(width < 50 ? .caption : width < 70 ? .body : .title2)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        if let minWidth {
                            Image(systemName: "photo.on.rectangle")
                                .font(minWidth < 50 ? .caption : minWidth < 70 ? .body : .title2)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        if let width {
            readyImage
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
            readyImage
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

