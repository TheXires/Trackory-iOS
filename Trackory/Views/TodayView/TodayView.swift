//
//  TodayView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Query private var consumptions: [Consumption]
    
    private var todayConsumptions: [Consumption] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return consumptions.filter { calendar.startOfDay(for: $0.date) == today }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todayConsumptions) { consumption in
                    TodayListRow(
                        consumption: consumption,
                        onIncrease: increaseQuantity,
                        onDecrease: decreaseQuantity
                    )
                }
                .onDelete(perform: deleteConsumptions)
            }
            .overlay {
                if todayConsumptions.isEmpty {
                    VStack(spacing: 12) {
                        Text("Nothing logged yet.")
                        Text("Add food from the Food tab.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Today")
        }
    }
    
    private func increaseQuantity(_ consumption: Consumption) {
        consumption.quantity += 1
    }
    
    private func decreaseQuantity(_ consumption: Consumption) {
        if consumption.quantity <= 1 {
            context.delete(consumption)
        } else {
            consumption.quantity -= 1
        }
    }
    
    private func deleteConsumptions(at offsets: IndexSet) {
        for index in offsets {
            context.delete(todayConsumptions[index])
        }
    }
}

#Preview {
    TodayView()
}
