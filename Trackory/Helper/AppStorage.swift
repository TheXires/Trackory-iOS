//
//  AppStorage.swift
//  Trackory
//
//  Created by Robin Beckmann on 28.01.26.
//

import SwiftUI
import Observation

enum UserDefaultsKey: String {
    case calorieTarget = "calorieTarget"
    case colorScheme = "colorScheme"
    case language = "language"
}

enum Design: String, CaseIterable, Codable {
    case system
    case light
    case dark
}

@Observable
class AppSettings {
    var calorieTarget: Float {
        didSet { save(calorieTarget, for: .calorieTarget) }
    }
    var design: Design {
        didSet { save(design, for: .colorScheme) }
    }
    var language: AppLanguage {
        didSet { save(language, for: .language) }
    }
    
    init() {
        calorieTarget = AppSettings.load(for: .calorieTarget, default: 2100)
        design        = AppSettings.load(for: .colorScheme,   default: .system)
        language      = AppSettings.load(for: .language,      default: .system)
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
