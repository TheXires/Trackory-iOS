//
//  Consumption.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import Foundation
import SwiftData

struct ConsumptionDTO: Codable {
    var calories: Int
    var carbohydrates: Int
    var date: Date
    var fat: Int
    var itemId: UUID
    var name: String
    var protein: Int
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
