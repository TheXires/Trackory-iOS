//
//  ContentView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppSettings.self) private var settings
    @AppStorage(UserDefaultsKey.colorScheme.rawValue) private var colorSchemeSetting: String = Design.system.rawValue
    
    @State private var selectedTab: Int = 0
    
    private var preferredScheme: ColorScheme? {
        switch Design(rawValue: colorSchemeSetting) ?? .system {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Today", systemImage: "fork.knife", value: 0) {
                TodayView()
            }
            Tab("Statistics", systemImage: "chart.bar.fill", value: 1) {
                WeeklyChartView()
            }
            Tab("Settings", systemImage: "gear", value: 2) {
                SettingsView()
            }
            Tab("Food", systemImage: "carrot.fill", value: 3, role: .search) {
                ItemListView()
            }
        }
        .preferredColorScheme(preferredScheme)
        .tabViewBottomAccessory(isEnabled: selectedTab == 0) {
            ProgressBarView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppSettings())
}
