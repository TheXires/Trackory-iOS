//
//  SettingsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    
    var body: some View {
        // @Observable braucht @Bindable für Bindings in Views
        @Bindable var settings = settings
        
        NavigationStack {
            List {
                Section(header: Text("Calorie Target")) {
                    NavigationLink {
                        CalorieTargetEditView(calorieTarget: $settings.calorieTarget)
                    } label: {
                        HStack {
                            Text("Daily Target")
                            Spacer()
                            Text("\(Int(settings.calorieTarget)) kcal")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Section(header: Text("Appearance")) {
                    Picker("Design", selection: $settings.design) {
                        ForEach(Design.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct CalorieTargetEditView: View {
    @Binding var calorieTarget: Float
    @State private var draft: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        List {
            Section(footer: Text("Set your daily calorie target in kcal.")) {
                TextField("e.g. 2100", text: $draft)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
            }
        }
        .navigationTitle("Calorie Target")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            draft = "\(Int(calorieTarget))"
            isFocused = true
        }
        .onChange(of: draft) { _, newValue in
            if let val = Float(newValue), val > 0 {
                calorieTarget = val
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}
