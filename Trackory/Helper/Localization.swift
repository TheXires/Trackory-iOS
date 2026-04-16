//
//  Localization.swift
//  Trackory
//
//  Created by Robin Beckmann on 16.04.26.
//

import SwiftUI

// MARK: - Language Enum

enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case system
    case english = "en"
    case german = "de"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: "System"
        case .english: "English"
        case .german: "Deutsch"
        }
    }
    
    /// Returns the Locale to apply. For `.system`, returns the device locale.
    var resolvedLocale: Locale {
        switch self {
        case .system: Locale.current
        case .english: Locale(identifier: "en")
        case .german: Locale(identifier: "de")
        }
    }
}
