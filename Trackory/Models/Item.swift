//
//  Item.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import Foundation
import SwiftData

struct ItemDTO: Codable {
    var calories: Int
    var carbohydrates: Int
    var fat: Int
    var name: String
    var protein: Int
    
    init(from item: Item) {
        self.calories = item.calories
        self.carbohydrates = item.carbohydrates
        self.fat = item.fat
        self.name = item.name
        self.protein = item.protein
    }
    
    func matches(_ item: Item) -> Bool {
        item.name == name &&
        item.calories == calories &&
        item.carbohydrates == carbohydrates &&
        item.fat == fat &&
        item.protein == protein
    }
}

@Model
class Item: Identifiable, Hashable {
    var id = UUID()
    var calories: Int
    var carbohydrates: Int
    var fat: Int
    var name: String
    var protein: Int
    
    init (calories: Int, carbohydrates: Int, fat: Int, name: String, protein: Int) {
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.name = name
        self.protein = protein
    }
}
