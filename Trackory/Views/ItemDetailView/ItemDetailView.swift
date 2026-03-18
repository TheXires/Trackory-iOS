//
//  ItemDetailView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var isEditMode: Bool = false
    @State var item: Item
    var onDeleteItem: (Item) -> Void
    
    var body: some View {
        VStack {
            Text("\(item.name)")
                .font(.title)
                .bold()
                .padding(50)
            ItemDetailNutritionView(item: item)
        }
        .sheet(isPresented: $isEditMode) {
            EditItemView(item: item)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    isEditMode = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                Button(role: .destructive) {
                    onDeleteItem(item)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    ItemDetailView(
        item: Item(calories: 100, carbohydrates: 0, fat: 0, name: "Toast", protein: 0),
        onDeleteItem: { _ in }
    )
}
