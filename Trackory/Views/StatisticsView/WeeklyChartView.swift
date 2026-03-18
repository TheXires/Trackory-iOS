//
//  WeeklyChartView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.03.26.
//

import SwiftUI
import SwiftData
import Charts

struct DayCalories: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Float
    let target: Float
    
    var weekday: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }
}

struct WeeklyChartView: View {
    @Environment(AppSettings.self) private var settings
    @Query private var consumptions: [Consumption]
    
    private var last7Days: [DayCalories] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let dayStart = calendar.startOfDay(for: date)
            
            let cals = consumptions
                .filter { calendar.startOfDay(for: $0.date) == dayStart }
                .reduce(0) { $0 + Float($1.calories * $1.quantity) }
            
            return DayCalories(date: date, calories: cals, target: settings.calorieTarget)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Chart(last7Days) { day in
                        BarMark(
                            x: .value("Day", day.date, unit: .day),
                            y: .value("Calories", day.calories)
                        )
                        .foregroundStyle(day.calories > day.target ? .red : .blue)
                        .cornerRadius(4)
                        
                        RuleMark(y: .value("Target", day.target))
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 3]))
                            .annotation(position: .top, alignment: .trailing) {
                                Text("Target: \(Int(day.target))")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                            }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                        }
                    }
                    .chartYAxis {
                        AxisMarks { mark in
                            AxisGridLine()
                            AxisValueLabel()
                        }
                    }
                    .frame(height: 250)
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Details")) {
                    ForEach(last7Days) { day in
                        HStack {
                            Text(day.date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
                                .font(.subheadline)
                            Spacer()
                            Text("\(Int(day.calories)) / \(Int(day.target)) kcal")
                                .font(.subheadline)
                                .foregroundStyle(day.calories > day.target ? .red : .secondary)
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    WeeklyChartView()
        .environment(AppSettings())
}
