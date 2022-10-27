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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                HStack {
                    Text("I want to read every day", comment: "part of a sentence 'I want to read every day %% pages.'")
                    
                    TextField("20", text: $newGoal)
                        .focused($isFocused)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .frame(width: 50)
                    
                    Text("pages.", comment: "part of a sentence 'I want to read every day %% pages.'")
                }
                
                Button("Update", action: update)
                    .buttonBorderShape(.capsule)
                    .controlSize(.mini)
                    .buttonStyle(.bordered)
                    .font(.system(size: 12))
                    .disabled(Int(newGoal) == nil)
            }
            .navigationTitle("Daily Goal")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                Button("Done") {
                    update()
                    dismiss()
                }
                
            }
            
            .onAppear {
                newGoal = String(dailyGoal)
                isFocused = true
            }
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
