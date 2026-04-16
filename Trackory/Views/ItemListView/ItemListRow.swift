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
    @Binding var selectedDate: Date
    
    @State private var rowFrame: CGRect = .zero
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Button {
                flyCoordinator.fly(from: CGPoint(x: rowFrame.midX, y: rowFrame.midY),
                                   size: rowFrame.size) {
                    rowContent
                }
                addConsumption()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.bordered)
            // Stop the button tap from also triggering the NavigationLink
            .simultaneousGesture(TapGesture())
        }
        // Capture the row's global frame without disrupting the layout
        .background {
            GeometryReader { geo in
                Color.clear
                    .onAppear { rowFrame = geo.frame(in: .global) }
                    .onChange(of: geo.frame(in: .global)) { _, new in rowFrame = new }
            }
        }
    }
    
    private var rowContent: some View {
        HStack {
            Text(item.name)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
    
    private func addConsumption() {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: selectedDate)
        
        // Fetch existing consumption for this item on the selected date
        let itemId = item.id
        let descriptor = FetchDescriptor<Consumption>(
            predicate: #Predicate { $0.itemId == itemId }
        )
        if let existing = try? context.fetch(descriptor).first(where: {
            calendar.startOfDay(for: $0.date) == targetDay
        }) {
            existing.quantity += 1
        } else {
            let consumption = Consumption(
                calories: item.calories,
                carbohydrates: item.carbohydrates,
                date: selectedDate,
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
        item: Item(calories: 100, carbohydrates: 0, fat: 0, name: "Toast", protein: 0),
        selectedDate: .constant(Date())
    )
    .environment(FlyToTabCoordinator())
}
