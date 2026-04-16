//
//  EditItemView.swift
//  Trackory
//
//  Created by Robin Beckmann on 12.03.26.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) var dismiss
    
    var item: Item
    
    @State private var name: String
    @State private var calories: Int?
    @State private var carbohydrates: Int?
    @State private var fat: Int?
    @State private var protein: Int?
    
    init(item: Item) {
        self.item = item
        _name         = State(initialValue: item.name)
        _calories     = State(initialValue: item.calories)
        _carbohydrates = State(initialValue: item.carbohydrates)
        _fat          = State(initialValue: item.fat)
        _protein      = State(initialValue: item.protein)
    }
    
    var body: some View {
        NavigationStack {
            ItemFormView(
                name: $name,
                calories: $calories,
                carbohydrates: $carbohydrates,
                fat: $fat,
                protein: $protein
            )
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        item.name          = name
                        item.calories      = calories ?? 0
                        item.carbohydrates = carbohydrates ?? 0
                        item.fat           = fat ?? 0
                        item.protein       = protein ?? 0
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    EditItemView(
        item: Item(calories: 100, carbohydrates: 20, fat: 5, name: "Toast", protein: 3)
    )
}
