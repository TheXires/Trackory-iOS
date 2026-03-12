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
        
        NavigationView {
            List {
                Section(header: Text("Calorie Target")) {
                    TextField("2100", value: $settings.calorieTarget, format: .number)
                        .keyboardType(.decimalPad)
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
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}
