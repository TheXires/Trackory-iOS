//
//  Consumption.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import Foundation
import SwiftData

struct ConsumptionDTO: Codable {
    var calories: Double
    var carbohydrates: Double
    var date: Date
    var fat: Double
    var itemId: UUID
    var name: String
    var protein: Double
    var quantity: Int

    init(from consumption: Consumption) {
        self.calories = consumption.calories
        self.carbohydrates = consumption.carbohydrates
        self.date = consumption.date
        self.fat = consumption.fat
        self.itemId = consumption.itemId
        self.name = consumption.name
        self.protein = consumption.protein
        self.quantity = consumption.quantity
    }
}

@Model
class Consumption: Identifiable, Hashable {
    var id = UUID()
    var calories: Double
    var carbohydrates: Double
    var date: Date
    var fat: Double
    var itemId: UUID
    var name: String
    var protein: Double
    var quantity: Int
    
    init(calories: Double,
         carbohydrates: Double,
         date: Date,
         fat: Double,
         itemId: UUID,
         name: String,
         protein: Double,
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
