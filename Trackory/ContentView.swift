//
//  ContentView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Int = 0
    @State private var searchTerm: String = ""
    
    var body: some View {
        TabView (selection: $selectedTab) {
            Tab("Today", systemImage: "fork.knife", value: 0) {
                TodayView()
            }
            
            Tab("Settings", systemImage: "gear", value: 1) {
                SettingsView()
            }
            
            Tab("Food", systemImage: "carrot.fill", value: 2, role: .search) {
                ItemListView()
            }
        }
        .tabViewBottomAccessory(isEnabled: selectedTab == 0) {
            ProgressBarView()
        }
    }
}

#Preview {
    ContentView()
}
