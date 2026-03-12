//
//  SettingsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

enum Design: String, CaseIterable, Codable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
//    var colorScheme: ColorScheme? {
//        switch self {
//            case .system: return nil
//            case .light: return .light
//            case .dark: return .dark
//        }
//    }
}

struct SettingsView: View {
    @TypedAppStorage(key: .calorieTarget, defaultValue: 2100) var calorieTarget: Float
    @TypedAppStorage(
        key: .colorScheme,
        defaultValue: .system
    ) var design: Design
    
    var colors = ["System", "Light", "Dark"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Calorie Target")) {
                    TextField("2100", value: $calorieTarget, format: .number)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Appearance")) {
                    Picker("Design", selection: $design) {
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
}
