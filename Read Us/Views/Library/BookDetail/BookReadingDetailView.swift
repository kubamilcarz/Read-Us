//
//  BookReadingDetailView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/21/22.
//

import SwiftUI

struct BookReadingDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var reading: BookReading
    
    @State private var startDate = Date()
    @State private var finishDate = Date()
    @State private var review = ""
    
    @State private var isFinished = false
    
    var body: some View {
        List {
            if let book = reading.book {
                HStack {
                    Text("Rating")
                    
                    Spacer()
                    
                    StarRatingCell(for: book, withResetButton: true)
                }
                
                TextField("What are your thoughts?", text: $review)
                    .lineLimit(1...10)
                
                Section {
                    Toggle(isOn: $isFinished.animation()) {
                        Text("Did you finish?")
                    }
                    
                    HStack {
                        Text("Start Date")
                        
                        Spacer()
                        
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    
                    if isFinished {
                        HStack {
                            Text("Finish Date")
                            
                            Spacer()
                            
                            DatePicker("Finish Date", selection: $finishDate, in: startDate..., displayedComponents: .date)
                                .labelsHidden()
                        }
                    }
                }
                
                Button {
                    reading.dateStarted = startDate
                    reading.dateFinished = isFinished ? finishDate : nil
                    
                    try? moc.save()
                    
                    dismiss()
                } label: {
                    Text("Save Changes")
                        .padding(.vertical, 7)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .withoutListInset()
                
                Section {
                    HStack {
                        Button(role: .cancel) {
                            reading.countToStats.toggle()
                            try? moc.save()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                moc.refresh(reading, mergeChanges: true)
                            }
                        } label: {
                            Label(reading.countToStats ? "Hide" : "Show", systemImage: "eye\(reading.countToStats ? ".slash" : "")")
                                .padding(.vertical, 7)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                        
                        Button(role: .destructive) {
                            moc.delete(reading)
                            try? moc.save()
                            
                            dismiss()
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .padding(.vertical, 7)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .withoutListInset()
                    .background(.clear)
                }
                .controlSize(.mini)
                .buttonBorderShape(.roundedRectangle)
                
            } else {
                Text("Something went wrong")
            }
        }
        .onAppear {
            review = reading.review_string
            
            startDate = reading.date_started
            
            isFinished = reading.dateFinished != nil
            
            finishDate = reading.date_finished
        }
              
        .navigationTitle(reading.book?.title_string ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
    }
}
