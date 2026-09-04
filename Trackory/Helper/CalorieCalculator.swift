//
//  CalorieCalculator.swift
//  Trackory
//
//  Created by Robin Beckmann on 03.09.26.
//

import Foundation

/// Pure, view-independent BMR and TDEE calculation (Mifflin-St Jeor).
/// Extracted from CalorieCalculatorView to allow unit testing.
enum CalorieCalculator {
    enum Sex: String, CaseIterable {
        case male, female
    }

    enum ActivityLevel: Double, CaseIterable {
        case sedentary   = 1.2
        case light       = 1.375
        case moderate    = 1.55
        case active      = 1.725
        case veryActive  = 1.9
    }

    enum WeightGoal: Double, CaseIterable {
        case lose     = -500
        case maintain = 0
        case gain     = 500
    }

    /// Basal Metabolic Rate (Mifflin-St Jeor).
    /// - Parameters:
    ///   - sex: Biological sex.
    ///   - age: Age in years.
    ///   - weightKg: Body weight in kilograms.
    ///   - heightCm: Height in centimetres.
    static func bmr(sex: Sex, age: Double, weightKg: Double, heightCm: Double) -> Double {
        let base = 10.0 * weightKg + 6.25 * heightCm - 5.0 * age
        return sex == .male ? base + 5 : base - 161
    }

    /// Total Daily Energy Expenditure rounded to the nearest integer, with a floor of 1 200 kcal.
    static func totalCalories(bmr: Double, activity: ActivityLevel, goal: WeightGoal) -> Int {
        max(1200, Int((bmr * activity.rawValue + goal.rawValue).rounded()))
    }
}
