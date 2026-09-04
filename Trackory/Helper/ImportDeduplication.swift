//
//  ImportDeduplication.swift
//  Trackory
//
//  Created by Robin Beckmann on 03.09.26.
//

import Foundation

/// Pure functions for import deduplication logic, extracted for testability.
enum ImportDeduplication {
    /// Returns true if the given ConsumptionDTO is a duplicate of an existing Consumption.
    /// Duplicate criteria: same itemId, same date (to the minute), same quantity.
    static func isDuplicateConsumption(_ entry: ConsumptionDTO, in existing: [Consumption]) -> Bool {
        existing.contains {
            $0.itemId == entry.itemId &&
            Calendar.current.isDate($0.date, equalTo: entry.date, toGranularity: .minute) &&
            $0.quantity == entry.quantity
        }
    }

    /// Returns true if the given ItemDTO is a duplicate of an existing Item.
    /// Delegate to ItemDTO.matches for value equality.
    static func isDuplicateItem(_ dto: ItemDTO, in existing: [Item]) -> Bool {
        existing.contains { dto.matches($0) }
    }
}
