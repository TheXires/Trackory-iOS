//
//  ConsumptionExtensions.swift
//  Trackory
//
//  Created by Robin Beckmann on 03.09.26.
//

import Foundation

extension [Consumption] {
    /// Returns only the consumptions that fall on the given calendar day.
    func on(_ date: Date, calendar: Calendar = .current) -> [Consumption] {
        let day = calendar.startOfDay(for: date)
        return filter { calendar.startOfDay(for: $0.date) == day }
    }

    var totalCalories: Float {
        reduce(0) { $0 + Float($1.calories * Double($1.quantity)) }
    }

    var totalProtein: Float {
        reduce(0) { $0 + Float($1.protein * Double($1.quantity)) }
    }

    var totalCarbs: Float {
        reduce(0) { $0 + Float($1.carbohydrates * Double($1.quantity)) }
    }

    var totalFat: Float {
        reduce(0) { $0 + Float($1.fat * Double($1.quantity)) }
    }
}
