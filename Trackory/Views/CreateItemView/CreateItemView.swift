//
//  CreateItemView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI
import SwiftData

// MARK: - Shared Form

struct ItemFormView: View {
    @FocusState private var isFieldFocused: Bool

    @Binding var name: String
    @Binding var calories: Double?
    @Binding var carbohydrates: Double?
    @Binding var fat: Double?
    @Binding var protein: Double?

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .focused($isFieldFocused)
            }
            Section {
                inlineField(label: String(localized: "Calories"), value: $calories, unit: "kcal")
                inlineField(label: String(localized: "Protein"), value: $protein, unit: "g")
                inlineField(label: String(localized: "Carbohydrates"), value: $carbohydrates, unit: "g")
                inlineField(label: String(localized: "Fat"), value: $fat, unit: "g")
            }
        }
        .onAppear {
            isFieldFocused = true
        }
    }

    @ViewBuilder
    private func inlineField(label: String, value: Binding<Double?>, unit: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
            Text(unit)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Create

struct CreateItemView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var name: String = ""
    @State private var calories: Double?
    @State private var carbohydrates: Double?
    @State private var fat: Double?
    @State private var protein: Double?

    var body: some View {
        NavigationStack {
            ItemFormView(
                name: $name,
                calories: $calories,
                carbohydrates: $carbohydrates,
                fat: $fat,
                protein: $protein
            )
            .navigationTitle("Create Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newItem = Item(
                            calories: calories ?? 0,
                            carbohydrates: carbohydrates ?? 0,
                            fat: fat ?? 0,
                            name: name,
                            protein: protein ?? 0
                        )
                        context.insert(newItem)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    CreateItemView()
}
