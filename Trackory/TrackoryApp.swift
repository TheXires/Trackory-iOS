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
    @State private var flyCoordinator = FlyToTabCoordinator()
    let modelContainer: ModelContainer

    init() {
        let schema = Schema(SchemaV1.models)
        let config = ModelConfiguration(schema: schema)
        do {
            modelContainer = try ModelContainer(for: schema, migrationPlan: TrackoryMigrationPlan.self, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
                .environment(flyCoordinator)
                .environment(\.locale, settings.language.resolvedLocale)
                .flyToTabAnimationOverlay(coordinator: flyCoordinator)
        }
        .modelContainer(modelContainer)
    }
}
