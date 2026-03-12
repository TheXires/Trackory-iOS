//
//  ItemListRow.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI
import SwiftData

struct ItemListRow: View {
    @Environment(\.modelContext) private var context
    var item: Item
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Button {
                addConsumption()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func addConsumption() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Fetch existing consumption for this item today
        let itemId = item.id
        let descriptor = FetchDescriptor<Consumption>(
            predicate: #Predicate { $0.itemId == itemId }
        )
        if let existing = try? context.fetch(descriptor).first(where: {
            calendar.startOfDay(for: $0.date) == today
        }) {
            existing.quantity += 1
        } else {
            let consumption = Consumption(
                calories: item.calories,
                carbohydrates: item.carbohydrates,
                date: Date(),
                fat: item.fat,
                itemId: item.id,
                name: item.name,
                protein: item.protein,
                quantity: 1
            )
            context.insert(consumption)
        }
    }
}

#Preview {
    ItemListRow(
        item: Item(calories: 100, carbohydrates: 0, fat: 0, name: "Toast", protein: 0)
    )
}

