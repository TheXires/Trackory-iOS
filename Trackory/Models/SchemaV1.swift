//
//  SchemaV1.swift
//  Trackory
//
//  Created by Robin Beckmann on 03.09.26.
//

import SwiftData

// MARK: - Schema V1 (baseline – current production schema)
//
// This file locks the current data model as Version 1.
// Future model changes must be introduced as SchemaV2 + a corresponding
// MigrationStage in TrackoryMigrationPlan to prevent data loss on update.

enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [Item.self, Consumption.self] }
}

enum TrackoryMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [SchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}
