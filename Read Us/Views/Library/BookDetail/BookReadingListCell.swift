//
//  BookReadingListCell.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct BookReadingListCell: View {
    
    var reading: BookReading
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: reading.dateFinished == nil ? "circle" : "checkmark.circle.fill")
                .foregroundColor(reading.dateFinished == nil ? .secondary : .ruAccentColor)
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    if reading.dateFinished == nil {
                        Text("\(reading.date_started.formatted(date: .abbreviated, time: .omitted)) - Now")
                            .font(.system(.caption2, design: .serif))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    } else {
                        Text("\(reading.date_started.formatted(date: .abbreviated, time: .omitted)) - \(reading.date_finished.formatted(date: .abbreviated, time: .omitted))")
                            .font(.system(.caption2, design: .serif))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        StarRatingCell(for: .constant(reading.rating_int))
                            .allowsHitTesting(false)
                    }
                }
                
                if reading.dateFinished != nil && reading.review_string.count > 0 {
                    Text(reading.review_string)
                        .font(.caption)
                }
            }
        }
    }
}
