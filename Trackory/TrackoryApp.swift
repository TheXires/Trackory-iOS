//
//  TrackoryApp.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData

@main
struct TrackoryApp: App {
    @State private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
        }
        .modelContainer(for: [Item.self, Consumption.self])
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
