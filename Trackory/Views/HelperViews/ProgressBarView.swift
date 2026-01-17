//
//  ProgressView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct ProgressBarView: View {
    var body: some View {
        ProgressView(
            value: 50,
            total: 100
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
