//
//  CalorieCalculatorView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.04.26.
//

import SwiftUI

struct CalorieCalculatorView: View {
    @Binding var calorieTarget: Float
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var settings
    
    enum Sex: String, CaseIterable {
        case male, female
        
        var label: LocalizedStringKey {
            switch self {
            case .male: "Male"
            case .female: "Female"
            }
        }
    }
    
    enum ActivityLevel: String, CaseIterable, Identifiable {
        case sedentary
        case light
        case moderate
        case active
        case veryActive
        
        var id: String { rawValue }
        
        var factor: Double {
            switch self {
            case .sedentary: 1.2
            case .light: 1.375
            case .moderate: 1.55
            case .active: 1.725
            case .veryActive: 1.9
            }
        }
        
        var label: LocalizedStringKey {
            switch self {
            case .sedentary: "Sedentary (little or no exercise)"
            case .light: "Lightly active (1-3 days/week)"
            case .moderate: "Moderately active (3-5 days/week)"
            case .active: "Active (6-7 days/week)"
            case .veryActive: "Very active (hard exercise daily)"
            }
        }
    }
    
    enum WeightGoal: String, CaseIterable, Identifiable {
        case lose
        case maintain
        case gain
        
        var id: String { rawValue }
        
        var calorieOffset: Double {
            switch self {
            case .lose: -500
            case .maintain: 0
            case .gain: +500
            }
        }
        
        var label: LocalizedStringKey {
            switch self {
            case .lose: "Lose weight"
            case .maintain: "Maintain weight"
            case .gain: "Gain weight"
            }
        }
    }
    
    private var sex: Sex {
        get { Sex(rawValue: settings.calcSex) ?? .male }
        nonmutating set { settings.calcSex = newValue.rawValue }
    }
    
    private var activityLevel: ActivityLevel {
        get { ActivityLevel(rawValue: settings.calcActivity) ?? .sedentary }
        nonmutating set { settings.calcActivity = newValue.rawValue }
    }
    
    private var weightGoal: WeightGoal {
        get { WeightGoal(rawValue: settings.calcGoal) ?? .maintain }
        nonmutating set { settings.calcGoal = newValue.rawValue }
    }
    
    private var age: Double? { Double(settings.calcAge) }
    private var weight: Double? { Double(settings.calcWeight) }
    private var height: Double? { Double(settings.calcHeight) }
    
    private var isInputComplete: Bool {
        guard let weight, let height, let age else { return false }
        return weight > 0 && height > 0 && age > 0
    }
    
    private var bmr: Double? {
        guard isInputComplete, let weight, let height, let age else { return nil }
        let base = 10.0 * weight + 6.25 * height - 5.0 * age
        switch sex {
        case .male: return base + 5
        case .female: return base - 161
        }
    }
    
    private var totalCalories: Int? {
        guard let bmr else { return nil }
        return max(1200, Int((bmr * activityLevel.factor + weightGoal.calorieOffset).rounded()))
    }
    
    var body: some View {
        @Bindable var settings = settings
        
        List {
            Section(header: Text("Personal Information")) {
                Picker("Sex", selection: Binding(get: { sex }, set: { sex = $0 })) {
                    ForEach(Sex.allCases, id: \.self) { s in
                        Text(s.label).tag(s)
                    }
                }
                HStack {
                    Text("Age")
                    Spacer()
                    TextField("e.g. 25", text: $settings.calcAge)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                HStack {
                    Text("Weight (kg)")
                    Spacer()
                    TextField("e.g. 75", text: $settings.calcWeight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                HStack {
                    Text("Height (cm)")
                    Spacer()
                    TextField("e.g. 180", text: $settings.calcHeight)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                Picker("Activity", selection: Binding(get: { activityLevel }, set: { activityLevel = $0 })) {
                    ForEach(ActivityLevel.allCases) { level in
                        Text(level.label).tag(level)
                    }
                }
                Picker("Goal", selection: Binding(get: { weightGoal }, set: { weightGoal = $0 })) {
                    ForEach(WeightGoal.allCases) { goal in
                        Text(goal.label).tag(goal)
                    }
                }
            }
            
            Section(header: Text("Result")) {
                if let totalCalories {
                    HStack {
                        Text("Daily Calorie Need")
                        Spacer()
                        Text("\(totalCalories) kcal")
                            .fontWeight(.semibold)
                    }
                    if let bmr {
                        HStack {
                            Text("Basal Metabolic Rate")
                            Spacer()
                            Text("\(Int(bmr.rounded())) kcal")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Text("Please fill in all fields above to calculate your daily calorie need.")
                        .foregroundStyle(.secondary)
                }
                Button {
                    if let totalCalories {
                        calorieTarget = Float(totalCalories)
                        dismiss()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Apply as Daily Target")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(!isInputComplete)
            }
        }
        .navigationTitle("Calorie Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CalorieCalculatorView(calorieTarget: .constant(2100))
            .environment(AppSettings())
    }
}
