//
//  UpdateDailyGoalSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/27/22.
//

import SwiftUI

struct UpdateDailyGoalSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("dailyGoal") var dailyGoal = 20
    @State private var newGoal = ""
    
    @FocusState private var isFocused: Bool
    var isNested: Bool
    
    init(isNested: Bool = false) {
        self.isNested = isNested
    }
    
    var body: some View {
        if isNested {
            ScrollView {
                content
            }
        } else {
            NavigationView {
                content
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                Text("I want to read every day", comment: "part of a sentence 'I want to read every day %% pages.'")
                
                TextField("20", text: $newGoal)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 50)
                
                Text("pages", comment: "part of a sentence 'I want to read every day %% pages.'")
            }
            
            Button(action: update) {
                Text("Update")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .disabled(Int(newGoal) == nil)
        }
        .padding(.horizontal)
        .navigationTitle("Daily Goal")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            if !isNested {
                Button("Done") {
                    update()
                    dismiss()
                }
            }
        }
        
        .onAppear {
            newGoal = String(dailyGoal)
            isFocused = true
        }
    }
    
    private func update() {
        withAnimation {
            if let newGoalInt = Int(newGoal) {
                dailyGoal = newGoalInt
                dismiss()
            }
        }
    }
}

struct UpdateDailyGoalSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateDailyGoalSheet()
    }
}
