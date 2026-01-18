//
//  ItemsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @State private var searchTerm: String = ""
    @State private var isPresented: Bool = false
    
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(items) { item in
                    Text(item.name)
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
