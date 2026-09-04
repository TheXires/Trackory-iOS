//
//  AppStorage.swift
//  Trackory
//
//  Created by Robin Beckmann on 28.01.26.
//

import SwiftUI
import Observation

enum UserDefaultsKey: String {
    case calorieTarget
    case proteinTarget
    case carbsTarget
    case fatTarget
    case colorScheme
    case language
    case calcSex
    case calcAge
    case calcWeight
    case calcHeight
    case calcActivity
    case calcGoal
}

enum Design: String, CaseIterable, Codable {
    case system
    case light
    case dark

    var displayName: LocalizedStringKey {
        switch self {
        case .system: "System"
        case .light:  "Light"
        case .dark:   "Dark"
        }
    }
}

@Observable
class AppSettings {
    var calorieTarget: Float {
        didSet { save(calorieTarget, for: .calorieTarget) }
    }
    var proteinTarget: Float {
        didSet { save(proteinTarget, for: .proteinTarget) }
    }
    var carbsTarget: Float {
        didSet { save(carbsTarget, for: .carbsTarget) }
    }
    var fatTarget: Float {
        didSet { save(fatTarget, for: .fatTarget) }
    }
    var design: Design {
        didSet { save(design, for: .colorScheme) }
    }
    var language: AppLanguage {
        didSet { save(language, for: .language) }
    }
    var calcSex: String {
        didSet { save(calcSex, for: .calcSex) }
    }
    var calcAge: Double? {
        didSet { save(calcAge, for: .calcAge) }
    }
    var calcWeight: Double? {
        didSet { save(calcWeight, for: .calcWeight) }
    }
    var calcHeight: Double? {
        didSet { save(calcHeight, for: .calcHeight) }
    }
    var calcActivity: String {
        didSet { save(calcActivity, for: .calcActivity) }
    }
    var calcGoal: String {
        didSet { save(calcGoal, for: .calcGoal) }
    }

    init() {
        calorieTarget = AppSettings.load(for: .calorieTarget, default: 2100)
        proteinTarget = AppSettings.load(for: .proteinTarget, default: 130)
        carbsTarget   = AppSettings.load(for: .carbsTarget,   default: 263)
        fatTarget     = AppSettings.load(for: .fatTarget,     default: 58)
        design        = AppSettings.load(for: .colorScheme,   default: .system)
        language      = AppSettings.load(for: .language,      default: .system)
        calcSex       = AppSettings.load(for: .calcSex,       default: "male")
        calcAge       = AppSettings.load(for: .calcAge,       default: nil)
        calcWeight    = AppSettings.load(for: .calcWeight,    default: nil)
        calcHeight    = AppSettings.load(for: .calcHeight,    default: nil)
        calcActivity  = AppSettings.load(for: .calcActivity,  default: "sedentary")
        calcGoal      = AppSettings.load(for: .calcGoal,      default: "maintain")
    }
    
    // MARK: - Persistence
    
    private static func load<T: Codable>(for key: UserDefaultsKey, default fallback: T) -> T {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue),
              let value = try? JSONDecoder().decode(T.self, from: data)
        else { return fallback }
        return value
    }
    
    private func save<T: Codable>(_ value: T, for key: UserDefaultsKey) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }
}
