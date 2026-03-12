//
//  ProgressView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct ProgressBarView: View {
    @TypedAppStorage(key: .calorieTarget, defaultValue: 2100) var calorieTarget: Float
    
    var body: some View {
        ProgressView(
            value: 50,
            total: calorieTarget
        ) {} currentValueLabel: {
            Text("50 calroies left")
        }
        .progressViewStyle(.linear)
        .padding()
    }
}

#Preview {
    ProgressView()
}
