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
    
    @Query private var items: [Item]
    
    var filteredItems: [Item] {
        let lowercasedSearchTerm = searchTerm.lowercased()
        return searchTerm.isEmpty ? items : items.filter {
            $0.name.lowercased().contains(lowercasedSearchTerm)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    NavigationLink(value: item) {
                        ItemListRow(item: item)
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
    ItemListView()
}
