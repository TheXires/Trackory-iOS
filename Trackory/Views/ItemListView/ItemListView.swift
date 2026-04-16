//
//  ItemsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Environment(\.modelContext) private var context
    @State private var searchTerm: String = ""
    @State private var isPresented: Bool = false
    @Binding var selectedDate: Date
    
    @Query private var items: [Item]
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    private var dateLabel: String {
        if isToday { return "Today" }
        if Calendar.current.isDateInYesterday(selectedDate) { return "Yesterday" }
        return selectedDate.formatted(.dateTime.day().month(.abbreviated).year())
    }
    
    var filteredItems: [Item] {
        let lowercasedSearchTerm = searchTerm.lowercased()
        let filtered = searchTerm.isEmpty ? items : items.filter {
            $0.name.lowercased().contains(lowercasedSearchTerm)
        }
        return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !isToday {
                    Section {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundStyle(.orange)
                            Text("Adding for **\(dateLabel)**")
                                .font(.subheadline)
                            Spacer()
                            Button("Today") {
                                withAnimation { selectedDate = Date() }
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    }
                }
                ForEach(filteredItems) { item in
                    NavigationLink(value: item) {
                        ItemListRow(item: item, selectedDate: $selectedDate)
                    }
                }
            }
            .overlay(VStack {
                if items.isEmpty {
                    Spacer().frame(maxHeight: 150)
                    Text("No items available.")
                    Spacer().frame(maxHeight: 15)
                    Text("Add first item to get started.")
                    Spacer()
                }
            })
            .scrollDisabled(items.isEmpty)
            .navigationDestination(for: Item.self) { item in
                ItemDetailView(item: item, onDeleteItem: { itemToDelete in
                    context.delete(itemToDelete)
                })
            }
            .navigationTitle("Food")
            .toolbar {
                Button {
                    isPresented.toggle()
                } label: {
                    Label("Create", systemImage: "plus")
                }
            }
        }
        .searchable(text: $searchTerm)
        .sheet(isPresented: $isPresented) {
            CreateItemView()
        }
    }
}

#Preview {
    ItemListView(selectedDate: .constant(Date()))
}
