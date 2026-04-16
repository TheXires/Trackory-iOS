//
//  WeeklyChartView.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.03.26.
//

import SwiftUI
import SwiftData
import Charts

// MARK: - Time Range

enum StatisticsRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    
    var id: String { rawValue }
}

// MARK: - Aggregated Bucket

struct CalorieBucket: Identifiable {
    let id = UUID()
    let date: Date
    let label: String
    let calories: Float
    let target: Float
    let days: Int
}

// MARK: - View

struct WeeklyChartView: View {
    @Environment(AppSettings.self) private var settings
    @Query private var consumptions: [Consumption]
    
    @State private var selectedRange: StatisticsRange = .week
    @State private var offset: Int = 0  // 0 = current, -1 = previous, etc.
    
    // MARK: Period label
    
    private var periodLabel: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        switch selectedRange {
        case .week:
            let endDate = calendar.date(byAdding: .weekOfYear, value: offset, to: today)!
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate)!
            if offset == 0 {
                return "This Week"
            }
            return "\(startDate.formatted(.dateTime.day().month(.abbreviated))) – \(endDate.formatted(.dateTime.day().month(.abbreviated)))"
        case .month:
            let refDate = calendar.date(byAdding: .month, value: offset, to: today)!
            let comps = calendar.dateComponents([.year, .month], from: refDate)
            let monthStart = calendar.date(from: comps)!
            if offset == 0 {
                return "This Month"
            }
            return monthStart.formatted(.dateTime.month(.wide).year())
        }
    }
    
    private var isCurrentPeriod: Bool { offset == 0 }
    
    // MARK: Data aggregation
    
    private var buckets: [CalorieBucket] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        switch selectedRange {
        case .week:
            let endDate = calendar.date(byAdding: .weekOfYear, value: offset, to: today)!
            return makeDailyBuckets(days: 7, endingAt: endDate, calendar: calendar, shortLabels: true)
        case .month:
            let refDate = calendar.date(byAdding: .month, value: offset, to: today)!
            let comps = calendar.dateComponents([.year, .month], from: refDate)
            let monthStart = calendar.date(from: comps)!
            let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
            let daysInMonth = calendar.dateComponents([.day], from: monthStart, to: monthEnd).day ?? 30
            return makeDailyBuckets(days: daysInMonth, endingAt: calendar.date(byAdding: .day, value: -1, to: monthEnd)!, calendar: calendar, shortLabels: false)
        }
    }
    
    private func makeDailyBuckets(days: Int, endingAt end: Date, calendar: Calendar, shortLabels: Bool) -> [CalorieBucket] {
        (0..<days).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: end)!
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            let cals = caloriesFor(start: dayStart, end: dayEnd)
            let label = shortLabels
            ? date.formatted(.dateTime.weekday(.abbreviated))
            : date.formatted(.dateTime.day().month(.abbreviated))
            return CalorieBucket(date: date, label: label, calories: cals, target: settings.calorieTarget, days: 1)
        }
    }
    
    private func caloriesFor(start: Date, end: Date) -> Float {
        consumptions
            .filter { $0.date >= start && $0.date < end }
            .reduce(0) { $0 + Float($1.calories * $1.quantity) }
    }
    
    // MARK: Chart axis config
    
    private var chartXAxisFormat: Date.FormatStyle {
        switch selectedRange {
        case .week: .dateTime.weekday(.abbreviated)
        case .month: .dateTime.day()
        }
    }
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                // Range picker
                Section {
                    Picker("Range", selection: $selectedRange) {
                        ForEach(StatisticsRange.allCases) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .onChange(of: selectedRange) { _, _ in
                        offset = 0
                    }
                }
                
                // Chart
                Section {
                    VStack(spacing: 8) {
                        HStack {
                            Button { offset -= 1 } label: {
                                Image(systemName: "chevron.left")
                                    .font(.caption)
                            }
                            .buttonStyle(.borderless)
                            
                            Spacer()
                            Text(periodLabel)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            
                            Button { offset += 1 } label: {
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .buttonStyle(.borderless)
                            .disabled(isCurrentPeriod)
                        }
                        
                        Chart(buckets) { bucket in
                            BarMark(
                                x: .value("Period", bucket.date, unit: .day),
                                y: .value("Calories", bucket.calories)
                            )
                            .foregroundStyle(bucket.calories > bucket.target ? .red : .blue)
                            .cornerRadius(4)
                            
                            RuleMark(y: .value("Target", bucket.target))
                                .foregroundStyle(.green)
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 3]))
                        }
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisGridLine()
                                AxisValueLabel(format: chartXAxisFormat, centered: true)
                            }
                        }
                        .chartYAxis {
                            AxisMarks { _ in
                                AxisGridLine()
                                AxisValueLabel()
                            }
                        }
                        .frame(height: 250)
                        .padding(.vertical, 8)
                        
                        HStack {
                            Circle().fill(.green).frame(width: 8, height: 8)
                            Text("Target (\(Int(settings.calorieTarget)) kcal/day)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Details
                Section(header: Text("Details")) {
                    ForEach(buckets.reversed()) { bucket in
                        HStack {
                            Text(detailLabel(for: bucket))
                                .font(.subheadline)
                            Spacer()
                            Text("\(Int(bucket.calories)) / \(Int(bucket.target)) kcal")
                                .font(.subheadline)
                                .foregroundStyle(bucket.calories > bucket.target ? .red : .secondary)
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
            .animation(.easeInOut, value: selectedRange)
            .animation(.easeInOut, value: offset)
        }
    }
    
    private func detailLabel(for bucket: CalorieBucket) -> String {
        switch selectedRange {
        case .week:
            bucket.date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
        case .month:
            bucket.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
        }
    }
}

#Preview {
    WeeklyChartView()
        .environment(AppSettings())
}
