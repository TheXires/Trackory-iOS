//
//  ConsumptionExtensionsTests.swift
//  TrackoryTests
//
//  Created by Robin Beckmann on 03.09.26.
//

import Testing
import Foundation
@testable import Trackory

// MARK: - Helpers

private func makeConsumption(
    calories: Double,
    protein: Double = 0,
    carbs: Double = 0,
    fat: Double = 0,
    quantity: Int = 1,
    date: Date = Date()
) -> Consumption {
    Consumption(
        calories: calories,
        carbohydrates: carbs,
        date: date,
        fat: fat,
        itemId: UUID(),
        name: "Test",
        protein: protein,
        quantity: quantity
    )
}

private func date(_ dayOffset: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: dayOffset, to: Calendar.current.startOfDay(for: Date()))!
}

// MARK: - Tests

struct ConsumptionExtensionsTests {

    // MARK: on(_:)

    @Test func onFiltersToCorrectDay() {
        let today = makeConsumption(calories: 100, date: date(0))
        let yesterday = makeConsumption(calories: 200, date: date(-1))
        let tomorrow = makeConsumption(calories: 300, date: date(1))

        let result = [today, yesterday, tomorrow].on(Date())
        #expect(result.count == 1)
        #expect(result.first?.calories == 100)
    }

    @Test func onReturnsEmptyWhenNoMatch() {
        let yesterday = makeConsumption(calories: 200, date: date(-1))
        let result = [yesterday].on(Date())
        #expect(result.isEmpty)
    }

    // MARK: totalCalories

    @Test func totalCaloriesMultipleEntries() {
        let a = makeConsumption(calories: 100, quantity: 2) // 200
        let b = makeConsumption(calories: 50,  quantity: 3) // 150
        let result = [a, b].totalCalories
        #expect(result == 350.0)
    }

    @Test func totalCaloriesEmpty() {
        let result = [Consumption]().totalCalories
        #expect(result == 0.0)
    }

    // MARK: totalProtein / Carbs / Fat

    @Test func totalMacrosAreCorrect() {
        let item = makeConsumption(calories: 0, protein: 10, carbs: 20, fat: 5, quantity: 2)
        // protein: 20, carbs: 40, fat: 10
        #expect([item].totalProtein == 20.0)
        #expect([item].totalCarbs   == 40.0)
        #expect([item].totalFat     == 10.0)
    }
}
