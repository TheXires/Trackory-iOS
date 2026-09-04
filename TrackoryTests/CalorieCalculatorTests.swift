//
//  CalorieCalculatorTests.swift
//  TrackoryTests
//
//  Created by Robin Beckmann on 03.09.26.
//

import Testing
@testable import Trackory

struct CalorieCalculatorTests {

    // MARK: BMR – male

    @Test func bmrMaleKnownValues() {
        // 30-year-old male, 75 kg, 180 cm
        // Mifflin-St Jeor: 10*75 + 6.25*180 - 5*30 + 5 = 750 + 1125 - 150 + 5 = 1730
        let result = CalorieCalculator.bmr(sex: .male, age: 30, weightKg: 75, heightCm: 180)
        #expect(result == 1730.0)
    }

    // MARK: BMR – female

    @Test func bmrFemaleKnownValues() {
        // 25-year-old female, 60 kg, 165 cm
        // Mifflin-St Jeor: 10*60 + 6.25*165 - 5*25 - 161 = 600 + 1031.25 - 125 - 161 = 1345.25
        let result = CalorieCalculator.bmr(sex: .female, age: 25, weightKg: 60, heightCm: 165)
        #expect(result == 1345.25)
    }

    // MARK: TDEE

    @Test func totalCaloriesSedentaryMaintain() {
        // BMR 1730, sedentary (1.2), maintain (0)
        // 1730 * 1.2 = 2076 → rounded = 2076
        let result = CalorieCalculator.totalCalories(bmr: 1730, activity: .sedentary, goal: .maintain)
        #expect(result == 2076)
    }

    @Test func totalCaloriesActiveGain() {
        // BMR 1730, active (1.725), gain (+500)
        // 1730 * 1.725 + 500 = 2984.25 + 500 = 3484.25 → rounded = 3484
        let result = CalorieCalculator.totalCalories(bmr: 1730, activity: .active, goal: .gain)
        #expect(result == 3484)
    }

    @Test func totalCaloriesFloorOf1200() {
        // Very low BMR that would otherwise fall below 1200
        let result = CalorieCalculator.totalCalories(bmr: 500, activity: .sedentary, goal: .lose)
        #expect(result == 1200)
    }
}
