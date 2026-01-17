//
//  Consumption.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import Foundation
import SwiftData

@Model
class Consumption: Identifiable, Hashable {
    var id = UUID()
    var calories: Int
    var carbohydrates: Int
    var date: Date
    var fat: Int
    var itemId: UUID
    var name: String
    var protein: Int
    var quantity: Int
    
    init(calories: Int,
         carbohydrates: Int,
         date: Date,
         fat: Int,
         itemId: UUID,
         name: String,
         protein: Int,
         quantity: Int) {
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.date = date
        self.fat = fat
        self.itemId = itemId
        self.name = name
        self.protein = protein
        self.quantity = quantity
    }
}
