//
//  ItemsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct ItemListView: View {
    @State private var searchTerm: String = ""
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            List {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
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
