//
//  ProgressView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData

struct ProgressBarView: View {
    @Environment(AppSettings.self) private var settings
    @Query private var consumptions: [Consumption]
    
    private var todayCalories: Float {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return consumptions
            .filter { calendar.startOfDay(for: $0.date) == today }
            .reduce(0) { $0 + Float($1.calories * $1.quantity) }
    }
    
    private var remaining: Float {
        max(settings.calorieTarget - todayCalories, 0)
    }
    
    var body: some View {
        ProgressView(
            value: min(todayCalories, settings.calorieTarget),
            total: settings.calorieTarget
        ) {} currentValueLabel: {
            Text("\(Int(remaining)) calories left")
        }
        .progressViewStyle(.linear)
        .padding()
    }
}

#Preview {
    ProgressBarView()
        .environment(AppSettings())
}
