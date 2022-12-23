//
//  ReadingLogList.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct ReadingLogList: View {
    
    var readings: [BookReading]
        
    var body: some View {
        ScrollView {
            VStack {
                if readings.isEmpty {
                    HStack {
                        VStack(spacing: 15) {
                            Image(systemName: "tray.fill")
                                .font(.title)
                            
                            Text("No read books")
                                .font(.body)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 50)
                } else {
                    BookLogList(readings: readings)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 75)
        }
        .navigationTitle("Reading Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}
