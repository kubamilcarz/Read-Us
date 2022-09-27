//
//  UpdateBookProgressSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/26/22.
//

import SwiftUI

struct UpdateBookProgressSheet: View {
    @EnvironmentObject var mainVM: MainViewModel
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    
    @State private var numberOfPagesToAdd = ""
    
    var newProgress: CGFloat {
        CGFloat(mainVM.getCurrentPage(for: book)) / CGFloat(book.numberOfPages)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    updateProgressForm
                }
                .padding()
                
                HStack(spacing: 15) {
                    Button(action: finishBook) {
                        Text("Finish")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: updateProgress) {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .controlSize(.small)
                .padding()
            }
            .navigationTitle("Update Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                .tint(.secondary)
            }
        }
        .onAppear {
            numberOfPagesToAdd = "\(mainVM.getCurrentPage(for: book))"
        }
    }
    
    private var updateProgressForm: some View {
        VStack(spacing: 15) {
            CustomProgressView(value: newProgress)
            
            HStack {
                Text("Where are you?")
                Spacer()
                HStack {
                    TextField("\(book.numberOfPages)", text: $numberOfPagesToAdd)
                        .keyboardType(.numberPad)
                        .frame(width: 70)
                        .textFieldStyle(.roundedBorder)
                    Text("/ \(book.numberOfPages)")
                }
            }
        }
    }
    
    private func updateProgress() {
        withAnimation {
            if let pages = Int(numberOfPagesToAdd) {
                mainVM.updateProgress(moc: moc, for: book, pages: pages)
                dismiss()
            }
        }
    }
    
    private func finishBook() {
        withAnimation {
            mainVM.finish(moc: moc, book: book)
            dismiss()
        }
    }
}
