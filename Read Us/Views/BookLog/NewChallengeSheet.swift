//
//  NewChallengeSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/23/22.
//

import SwiftUI

struct NewChallengeSheet: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var dataManager: DataManager
    
    @FetchRequest<YearlyChallenge>(sortDescriptors: []) var challenges: FetchedResults<YearlyChallenge>
    
    var year: String
    var challenge: YearlyChallenge?
    
    init(year: String) {
        self.year = year
        self._goalAsText = State(wrappedValue: "20")
        self._challenges = FetchRequest<YearlyChallenge>(sortDescriptors: [])
    }
    
    init(challenge: YearlyChallenge) {
        self.year = String(challenge.year_int)
        self.challenge = challenge
        self._challenges = FetchRequest<YearlyChallenge>(sortDescriptors: [])
        self._goalAsText = State(wrappedValue: String(challenge.goal_int))
    }
    
    
    var sortedChallenges: [YearlyChallenge] {
        challenges.sorted { $0.year_int > $1.year_int }
    }
    
    var doesChallengeAlreadyExist: Bool {
        sortedChallenges.first(where: { $0.year_int == Int(year) }) != nil
    }
    
    var goalAsInt: Int {
        Int(goalAsText) ?? 0
    }
        
    @State private var goalAsText: String
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 50) {
                    VStack {
                        Text(year)
                            .font(.system(size: 64, design: .serif))
                            .bold()
                        Text("Challenge")
                            .font(.title3)
                            .textCase(.uppercase)
                            .bold()
                            .opacity(0.5)
                    }
                    .padding(.vertical, 50)
                    
                    VStack(spacing: 10) {
                        Text("I pledge to read", comment: "part of sentance 'i pledge to read 20 books'")
                            .font(.system(.body, design: .serif))
                            .foregroundColor(.secondary)
                        
                        TextField("20", text: $goalAsText)
                            .font(.system(size: 100, design: .serif))
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(width: 230)
                            .focused($isFieldFocused)
                            .keyboardType(.numberPad)
                            .overlay(
                                ZStack(alignment: .topTrailing) {
                                    if Int(goalAsText) == nil {
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(.red, lineWidth: 2, antialiased: true)
                                    Image(systemName: "exclamationmark.circle")
                                        .padding(6)
                                        .foregroundColor(.red)
                                    }
                                }
                                .padding(2)
                            )
                        
                        Text("books", comment: "part of sentance 'i pledge to read 20 books'")
                            .font(.system(.body, design: .serif))
                            .foregroundColor(.secondary)
                        
                    }
                }
                .padding(.vertical, 50)
            }

            closeButton
            
            startButton
        }
        .tint(.ruAccentColor)
        .onAppear {
            isFieldFocused = true
        }
    }
    
    private func saveChallenge() {
        
        if doesChallengeAlreadyExist == false {
            dataManager.startNewChallenge(moc: moc, year: Int(year) ?? 0, pledgedGoal: goalAsInt)
        } else {
            if let challenge {
                dataManager.updateChallenge(moc: moc, challenge: challenge, newGoal: goalAsInt)
            }
        }
        
        dismiss()
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var startButton: some View {
        Button(action: saveChallenge) {
            Text(doesChallengeAlreadyExist ? "Update" : "Start")
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .disabled(Int(goalAsText) == nil)
    }
}

struct NewChallengeSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewChallengeSheet(year: "2024")
    }
}
