//
//  SettingsSheet.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/31/22.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State private var isShowingUpdateDailyGoalSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        BackupView()
                    } label: {
                        Label("Backup", systemImage: "arrowshape.turn.up.backward.badge.clock")
                    }
                    
                    NavigationLink {
                        DataRemovalView()
                    } label: {
                        Label("Data Removal", systemImage: "trash")
                    }
                }
                
                Section {
                    NavigationLink {
                        UpdateDailyGoalSheet(isNested: true)
                    } label: {
                        Label("Reading Daily Goal", systemImage: "flame")
                    }
                    .buttonStyle(.plain)
                }
                
                
                Section {
                    VStack(spacing: 10) {
                        Image("logo")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                        
                        Text("Bookie")
                            .fontWeight(.bold)
                        
                        HStack { Spacer() }
                        
                        Text("Version: \(appVersion ?? "")")
                        
                        Text("© Bookie 2022. All Rights Reserved")
                    }
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    NavigationLink {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Hi, it's Kuba. I'd like to thank you for using Bookie!")
                                Text("My idea for the app was to create a privacy-oriented, but feature-rich book tracking app that would encourage you to hit your goals and read more.")
                                Text("Bookie is the app I've always dreamed about and I'm so excited it's finally here!")
                                
                                Divider()
                                    .padding(.vertical)
                                
                                Text("And while you're here I'd like to invite you to check out other apps I've made.")
                                Text("https://apps.apple.com/us/app/memorize-flashcards/id1631928972")
                            }
                            .padding()
                            .font(.system(.subheadline, design: .serif))
                        }
                        .navigationTitle("Words from Author")
                        .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Words from Author", systemImage: "signature")
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("API Use")
                            .font(.headline)
                        
                        Text("Bookie sends a call to Open Library API every time you use Scan Book feature when adding a new book to the library. For further information, visit https://openlibrary.org/developers/api")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .sheet(isPresented: $isShowingUpdateDailyGoalSheet) {
                UpdateDailyGoalSheet()
                    .presentationDetents([.height(200)])
            }
        }
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
