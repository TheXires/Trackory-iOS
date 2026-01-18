//
//  CreateItemView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI
import SwiftData

struct CreateItemView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @FocusState private var isFieldFocused: Bool
    
    @State private var calories: Int?
    @State private var carbohydrates: Int?
    @State private var fat: Int?
    @State private var name: String = ""
    @State private var protein: Int?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .focused($isFieldFocused)
                NumberField(name: "Calories", value: $calories)
                NumberField(name: "Carbohydrates", value: $carbohydrates)
                NumberField(name: "Fat", value: $fat)
                NumberField(name: "Protein", value: $protein)
            }
            .navigationTitle("Create Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .confirm) {
                        let newItem = Item(
                            calories: calories ?? 0,
                            carbohydrates: carbohydrates ?? 0,
                            fat: fat ?? 0,
                            name: name,
                            protein: protein ?? 0
                        )
                        context.insert(newItem)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear() {
                isFieldFocused.toggle()
            }
        }
        
    }
}

#Preview {
    CreateItemView()
}
