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
                ItemDetailRow(title: "Calories", content: "\(item.calories)")
                ItemDetailRow(title: "Carbohydrates", content: "\(item.carbohydrates)")
                ItemDetailRow(title: "Protein", content: "\(item.protein)")
                ItemDetailRow(title: "Fat", content: "\(item.fat)")
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
