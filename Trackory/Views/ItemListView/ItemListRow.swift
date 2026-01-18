//
//  ItemListRow.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI

struct ItemListRow: View {
    var item: Item
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Button {
                // TODO: Add Item to todays consumptions
                print("Add \(item.name)")
            } label: {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ItemListRow(
        item: Item(calories: 100, carbohydrates: 0, fat: 0, name: "Toast", protein: 0)
    )
}
