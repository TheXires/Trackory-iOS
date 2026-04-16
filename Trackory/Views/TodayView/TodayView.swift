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
    @Binding var selectedDate: Date
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    private var dateConsumptions: [Consumption] {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: selectedDate)
        return consumptions.filter { calendar.startOfDay(for: $0.date) == day }
    }
    
    private var dateLabel: String {
        if isToday { return String(localized: "Today") }
        if Calendar.current.isDateInYesterday(selectedDate) { return String(localized: "Yesterday") }
        return selectedDate.formatted(.dateTime.day().month(.abbreviated).year())
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dateConsumptions) { consumption in
                    TodayListRow(
                        consumption: consumption,
                        onIncrease: increaseQuantity,
                        onDecrease: decreaseQuantity
                    )
                }
                .onDelete(perform: deleteConsumptions)
            }
            .overlay {
                if dateConsumptions.isEmpty {
                    VStack(spacing: 12) {
                        Text("Nothing logged yet.")
                        Text("Add food from the Food tab.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(dateLabel)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(isToday)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if !isToday {
                        Button("Today") {
                            withAnimation { selectedDate = Date() }
                        }
                        .buttonStyle(.automatic)
                    }
                }
            }
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
            context.delete(dateConsumptions[index])
        }
    }
}

#Preview {
    TodayView(selectedDate: .constant(Date()))
}
