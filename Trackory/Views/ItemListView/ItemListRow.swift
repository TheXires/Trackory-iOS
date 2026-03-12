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
    @Environment(FlyToTabCoordinator.self) private var flyCoordinator
    var item: Item
    
    var body: some View {
        GeometryReader { geo in
            rowContent
                .onTapGesture { } // keeps tap handling on button only
                .overlay(alignment: .trailing) {
                    Button {
                        let frame = geo.frame(in: .global)
                        let origin = CGPoint(x: frame.midX, y: frame.midY)
                        flyCoordinator.fly(from: origin, size: frame.size) {
                            rowContent
                        }
                        addConsumption()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.bordered)
                    .padding(.trailing, 4)
                }
                .frame(height: 44)
        }
        .frame(height: 44)
    }
    
    private var rowContent: some View {
        HStack {
            Text(item.name)
            Spacer()
            Image(systemName: "plus")
                .frame(width: 20, height: 20)
                .buttonStyle(.bordered)
                .opacity(0) // placeholder to keep layout stable
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
    .environment(FlyToTabCoordinator())
}
