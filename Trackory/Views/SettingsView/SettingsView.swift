//
//  SettingsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

// Wraps the full export payload; each field is optional so partial exports work.
struct TrackoryExportDTO: Codable {
    var items: [ItemDTO]?
    var history: [ConsumptionDTO]?
}

enum ExportScope {
    case items, history, both
}

enum ImportScope {
    case items, history, both
}

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var consumptions: [Consumption]

    @State private var showExportScopeSheet = false
    @State private var showImportScopeSheet = false
    @State private var showExporter = false
    @State private var showImporter = false
    @State private var importResult: ImportResult?
    @State private var showImportAlert = false
    @State private var exportDocument: JSONDocument?
    @State private var pendingImportScope: ImportScope = .both

    var body: some View {
        // @Observable braucht @Bindable für Bindings in Views
        @Bindable var settings = settings

        NavigationStack {
            List {
                Section(header: Text("Calorie Target")) {
                    NavigationLink {
                        CalorieTargetEditView(calorieTarget: $settings.calorieTarget)
                    } label: {
                        HStack {
                            Text("Daily Target")
                            Spacer()
                            Text("\(Int(settings.calorieTarget)) kcal")
                                .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink {
                        CalorieCalculatorView(calorieTarget: $settings.calorieTarget)
                    } label: {
                        Text("Calorie Calculator")
                    }
                }
                Section(header: Text("Appearance")) {
                    Picker("Design", selection: $settings.design) {
                        ForEach(Design.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }
                }
                Section(header: Text("Language")) {
                    Picker("Language", selection: $settings.language) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text(lang.displayName)
                                .tag(lang)
                        }
                    }
                }
                Section(header: Text("Data")) {
                    Button {
                        showExportScopeSheet = true
                    } label: {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                    .confirmationDialog("Export Data", isPresented: $showExportScopeSheet, titleVisibility: .visible) {
                        Button("Export Items") { prepareExport(scope: .items) }
                        Button("Export History") { prepareExport(scope: .history) }
                        Button("Export Items & History") { prepareExport(scope: .both) }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Choose what to export")
                    }
                    Button {
                        showImportScopeSheet = true
                    } label: {
                        Label("Import Data", systemImage: "square.and.arrow.down")
                    }
                    .confirmationDialog("Import Data", isPresented: $showImportScopeSheet, titleVisibility: .visible) {
                        Button("Import Items") {
                            pendingImportScope = .items
                            showImporter = true
                        }
                        Button("Import History") {
                            pendingImportScope = .history
                            showImporter = true
                        }
                        Button("Import Items & History") {
                            pendingImportScope = .both
                            showImporter = true
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Choose what to import")
                    }
                }
            }
            .navigationTitle("Settings")
            .fileExporter(
                isPresented: $showExporter,
                document: exportDocument,
                contentType: .json,
                defaultFilename: "trackory_export.json"
            ) { _ in }
            .fileImporter(
                isPresented: $showImporter,
                allowedContentTypes: [.json]
            ) { result in
                guard let url = try? result.get(),
                      url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }
                guard let data = try? Data(contentsOf: url) else { return }

                handleImport(data: data, scope: pendingImportScope)
            }
            .alert("Import Complete", isPresented: $showImportAlert) {
                Button("OK") { }
            } message: {
                if let r = importResult {
                    Text(importSummary(r))
                }
            }
        }
    }

    // MARK: - Export

    private func prepareExport(scope: ExportScope) {
        let dto: TrackoryExportDTO
        switch scope {
        case .items:
            dto = TrackoryExportDTO(items: items.map { ItemDTO(from: $0) }, history: nil)
        case .history:
            dto = TrackoryExportDTO(items: nil, history: consumptions.map { ConsumptionDTO(from: $0) })
        case .both:
            dto = TrackoryExportDTO(
                items: items.map { ItemDTO(from: $0) },
                history: consumptions.map { ConsumptionDTO(from: $0) }
            )
        }
        if let data = try? JSONEncoder().encode(dto) {
            exportDocument = JSONDocument(data: data)
            showExporter = true
        }
    }

    // MARK: - Import

    private func handleImport(data: Data, scope: ImportScope) {
        // Try new combined format first, fall back to legacy [ItemDTO] array.
        var addedItems = 0
        var skippedItems = 0
        var addedHistory = 0
        var skippedHistory = 0

        if let dto = try? JSONDecoder().decode(TrackoryExportDTO.self, from: data) {
            if scope != .history, let dtoItems = dto.items {
                for item in dtoItems {
                    if items.contains(where: { item.matches($0) }) {
                        skippedItems += 1
                    } else {
                        modelContext.insert(Item(
                            calories: item.calories,
                            carbohydrates: item.carbohydrates,
                            fat: item.fat,
                            name: item.name,
                            protein: item.protein
                        ))
                        addedItems += 1
                    }
                }
            }
            if scope != .items, let dtoHistory = dto.history {
                for entry in dtoHistory {
                    let isDuplicate = consumptions.contains {
                        $0.itemId == entry.itemId &&
                        Calendar.current.isDate($0.date, equalTo: entry.date, toGranularity: .minute) &&
                        $0.quantity == entry.quantity
                    }
                    if isDuplicate {
                        skippedHistory += 1
                    } else {
                        modelContext.insert(Consumption(
                            calories: entry.calories,
                            carbohydrates: entry.carbohydrates,
                            date: entry.date,
                            fat: entry.fat,
                            itemId: entry.itemId,
                            name: entry.name,
                            protein: entry.protein,
                            quantity: entry.quantity
                        ))
                        addedHistory += 1
                    }
                }
            }
        } else if scope != .history,
                  let legacyItems = try? JSONDecoder().decode([ItemDTO].self, from: data) {
            // Legacy export: plain [ItemDTO] array
            for item in legacyItems {
                if items.contains(where: { item.matches($0) }) {
                    skippedItems += 1
                } else {
                    modelContext.insert(Item(
                        calories: item.calories,
                        carbohydrates: item.carbohydrates,
                        fat: item.fat,
                        name: item.name,
                        protein: item.protein
                    ))
                    addedItems += 1
                }
            }
        }

        importResult = ImportResult(
            addedItems: addedItems,
            skippedItems: skippedItems,
            addedHistory: addedHistory,
            skippedHistory: skippedHistory
        )
        showImportAlert = true
    }

    private func importSummary(_ r: ImportResult) -> String {
        var parts: [String] = []
        if r.addedItems > 0 || r.skippedItems > 0 {
            parts.append(String(format: NSLocalizedString("%lld items added, %lld duplicates skipped.", comment: ""), r.addedItems, r.skippedItems))
        }
        if r.addedHistory > 0 || r.skippedHistory > 0 {
            parts.append(String(format: NSLocalizedString("%lld history entries added, %lld duplicates skipped.", comment: ""), r.addedHistory, r.skippedHistory))
        }
        if parts.isEmpty {
            return NSLocalizedString("Nothing was imported.", comment: "")
        }
        return parts.joined(separator: "\n")
    }
}

struct CalorieTargetEditView: View {
    @Binding var calorieTarget: Float
    @State private var draft: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        List {
            Section(footer: Text("Set your daily calorie target in kcal.")) {
                TextField("e.g. 2100", text: $draft)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
            }
        }
        .navigationTitle("Calorie Target")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            draft = "\(Int(calorieTarget))"
            isFocused = true
        }
        .onChange(of: draft) { _, newValue in
            if let val = Float(newValue), val > 0 {
                calorieTarget = val
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}

struct ImportResult {
    let addedItems: Int
    let skippedItems: Int
    let addedHistory: Int
    let skippedHistory: Int

    // Backwards compatibility
    var added: Int { addedItems }
    var skipped: Int { skippedItems }
}

struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
