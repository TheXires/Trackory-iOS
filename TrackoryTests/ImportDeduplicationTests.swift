//
//  ImportDeduplicationTests.swift
//  TrackoryTests
//
//  Created by Robin Beckmann on 03.09.26.
//

import Testing
import Foundation
@testable import Trackory

// MARK: - Helpers

private let sharedItemId = UUID()

private func makeItem(name: String = "Apple", calories: Double = 52) -> Item {
    Item(calories: calories, carbohydrates: 14, fat: 0.2, name: name, protein: 0.3)
}

private func makeItemDTO(name: String = "Apple", calories: Double = 52) -> ItemDTO {
    ItemDTO(calories: calories, carbohydrates: 14, fat: 0.2, name: name, protein: 0.3)
}

private func makeConsumption(date: Date = Date(), quantity: Int = 1) -> Consumption {
    Consumption(
        calories: 52, carbohydrates: 14, date: date,
        fat: 0.2, itemId: sharedItemId, name: "Apple",
        protein: 0.3, quantity: quantity
    )
}

private func makeConsumptionDTO(date: Date = Date(), quantity: Int = 1) -> ConsumptionDTO {
    ConsumptionDTO(
        calories: 52, carbohydrates: 14, date: date,
        fat: 0.2, itemId: sharedItemId, name: "Apple",
        protein: 0.3, quantity: quantity
    )
}

// MARK: - Tests

struct ImportDeduplicationTests {

    // MARK: Items

    @Test func itemIsDuplicate() {
        let existing = makeItem()
        let dto = makeItemDTO()
        #expect(ImportDeduplication.isDuplicateItem(dto, in: [existing]) == true)
    }

    @Test func itemIsNotDuplicateWhenDifferentCalories() {
        let existing = makeItem(calories: 52)
        let dto = makeItemDTO(calories: 100)
        #expect(ImportDeduplication.isDuplicateItem(dto, in: [existing]) == false)
    }

    @Test func itemIsNotDuplicateWhenDifferentName() {
        let existing = makeItem(name: "Apple")
        let dto = makeItemDTO(name: "Banana")
        #expect(ImportDeduplication.isDuplicateItem(dto, in: [existing]) == false)
    }

    @Test func itemIsNotDuplicateWhenListEmpty() {
        #expect(ImportDeduplication.isDuplicateItem(makeItemDTO(), in: []) == false)
    }

    // MARK: Consumption history

    @Test func consumptionIsDuplicate() {
        let now = Date()
        let existing = makeConsumption(date: now, quantity: 1)
        let dto = makeConsumptionDTO(date: now, quantity: 1)
        #expect(ImportDeduplication.isDuplicateConsumption(dto, in: [existing]) == true)
    }

    @Test func consumptionIsNotDuplicateWhenDifferentQuantity() {
        let now = Date()
        let existing = makeConsumption(date: now, quantity: 1)
        let dto = makeConsumptionDTO(date: now, quantity: 2)
        #expect(ImportDeduplication.isDuplicateConsumption(dto, in: [existing]) == false)
    }

    @Test func consumptionIsNotDuplicateWhenDifferentDate() {
        let now = Date()
        let later = now.addingTimeInterval(120) // 2 min later → different minute
        let existing = makeConsumption(date: now, quantity: 1)
        let dto = makeConsumptionDTO(date: later, quantity: 1)
        #expect(ImportDeduplication.isDuplicateConsumption(dto, in: [existing]) == false)
    }

    @Test func consumptionIsNotDuplicateWhenListEmpty() {
        #expect(ImportDeduplication.isDuplicateConsumption(makeConsumptionDTO(), in: []) == false)
    }
}
