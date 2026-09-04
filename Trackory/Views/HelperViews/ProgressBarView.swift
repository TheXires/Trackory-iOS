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

    var selectedDate: Date = Date()

    @State private var showDetail = false

    private var dayConsumptions: [Consumption] {
        consumptions.on(selectedDate)
    }

    private var totalCalories: Float {
        dayConsumptions.totalCalories
    }

    private var remainingCalories: Float {
        max(settings.calorieTarget - totalCalories, 0)
    }

    var body: some View {
        Button {
            showDetail = true
        } label: {
            VStack(spacing: 4) {
                ProgressView(
                    value: min(totalCalories, settings.calorieTarget),
                    total: settings.calorieTarget
                ) {} currentValueLabel: {
                    Text("\(Int(remainingCalories)) calories left")
                }
                .progressViewStyle(.linear)
            }
            .padding()
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .sheet(isPresented: $showDetail) {
            MacroDetailView(selectedDate: selectedDate)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Detail Sheet

struct MacroDetailView: View {
    @Environment(AppSettings.self) private var settings
    @Query private var consumptions: [Consumption]

    var selectedDate: Date

    private var dayConsumptions: [Consumption] {
        consumptions.on(selectedDate)
    }

    private var totalCalories: Float { dayConsumptions.totalCalories }
    private var totalProtein: Float  { dayConsumptions.totalProtein }
    private var totalCarbs: Float    { dayConsumptions.totalCarbs }
    private var totalFat: Float      { dayConsumptions.totalFat }

    private var remainingCalories: Float {
        max(settings.calorieTarget - totalCalories, 0)
    }

    var body: some View {
        List {
            Section {
                macroRow(
                    label: String(localized: "Calories"),
                    value: totalCalories,
                    target: settings.calorieTarget,
                    color: .green,
                    unit: "kcal"
                )
            }
            Section {
                macroRow(
                    label: String(localized: "Protein"),
                    value: totalProtein,
                    target: settings.proteinTarget,
                    color: .blue,
                    unit: "g"
                )
                macroRow(
                    label: String(localized: "Carbohydrates"),
                    value: totalCarbs,
                    target: settings.carbsTarget,
                    color: .orange,
                    unit: "g"
                )
                macroRow(
                    label: String(localized: "Fat"),
                    value: totalFat,
                    target: settings.fatTarget,
                    color: .yellow,
                    unit: "g"
                )
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Nutrition")
    }

    @ViewBuilder
    private func macroRow(label: String, value: Float, target: Float, color: Color, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(value)) / \(Int(target)) \(unit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: min(value, target), total: target)
                .progressViewStyle(.linear)
                .tint(color)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProgressBarView()
        .environment(AppSettings())
}
