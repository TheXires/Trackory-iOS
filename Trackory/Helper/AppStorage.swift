//
//  AppStorage.swift
//  Trackory
//
//  Created by Robin Beckmann on 28.01.26.
//

import SwiftUI

enum UserDefaultsKey: String {
    case calorieTarget = "calorieTarget"
    case colorScheme = "colorScheme"
}

@propertyWrapper
struct TypedAppStorage<T: Codable> {
    let key: UserDefaultsKey
    let defaultValue: T
    var storage: UserDefaults = .standard
    
    var wrappedValue: T {
        get {
            // Wir lesen die Daten als 'Data' (JSON)
            guard let data = storage.data(forKey: key.rawValue) else {
                return defaultValue
            }
            // Und verwandeln sie zurück in deinen Typ T
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        set {
            // Wir verwandeln das Objekt in JSON-Data
            if let encoded = try? JSONEncoder().encode(newValue) {
                storage.set(encoded, forKey: key.rawValue)
            }
        }
    }
    
    var projectedValue: Binding<T> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
