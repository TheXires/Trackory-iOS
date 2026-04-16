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
    @Binding var calories: Int?
    @Binding var carbohydrates: Int?
    @Binding var fat: Int?
    @Binding var protein: Int?
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .focused($isFieldFocused)
            NumberField(name: String(localized: "Calories"), value: $calories)
            NumberField(name: String(localized: "Carbohydrates"), value: $carbohydrates)
            NumberField(name: String(localized: "Fat"), value: $fat)
            NumberField(name: String(localized: "Protein"), value: $protein)
        }
        .onAppear {
            isFieldFocused = true
        }
    }
}

// MARK: - Create

struct CreateItemView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var calories: Int?
    @State private var carbohydrates: Int?
    @State private var fat: Int?
    @State private var protein: Int?
    
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
