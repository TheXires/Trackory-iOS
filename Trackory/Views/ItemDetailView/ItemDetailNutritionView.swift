//
//  ItemDetailNutritionView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI

struct ItemDetailNutritionView: View {
    var item: Item
    
    var body: some View {
        List {
            Section {
                ItemDetailRow(title: String(localized: "Calories"), content: "\(item.calories.formatted(.number.precision(.fractionLength(0...1)))) kcal")
                ItemDetailRow(title: String(localized: "Carbohydrates"), content: "\(item.carbohydrates.formatted(.number.precision(.fractionLength(0...1)))) g")
                ItemDetailRow(title: String(localized: "Protein"), content: "\(item.protein.formatted(.number.precision(.fractionLength(0...1)))) g")
                ItemDetailRow(title: String(localized: "Fat"), content: "\(item.fat.formatted(.number.precision(.fractionLength(0...1)))) g")
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
    }
}

#Preview {
    ItemDetailNutritionView(
        item: Item(calories: 100, carbohydrates: 0, fat: 0, name: "Toast", protein: 0)
    )
}
