//
//  SettingsView.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var showExporter = false
    @State private var showImporter = false
    @State private var importResult: ImportResult?
    @State private var showImportAlert = false
    @State private var exportDocument: JSONDocument?
    
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
                        Label("Calorie Calculator", systemImage: "function")
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
                        let dtos = items.map { ItemDTO(from: $0) }
                        if let data = try? JSONEncoder().encode(dtos) {
                            exportDocument = JSONDocument(data: data)
                            showExporter = true
                        }
                    } label: {
                        Label("Export Items", systemImage: "square.and.arrow.up")
                    }
                    Button {
                        showImporter = true
                    } label: {
                        Label("Import Items", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .navigationTitle("Settings")
            .fileExporter(
                isPresented: $showExporter,
                document: exportDocument,
                contentType: .json,
                defaultFilename: "trackory_items.json"
            ) { _ in }
                .fileImporter(
                    isPresented: $showImporter,
                    allowedContentTypes: [.json]
                ) { result in
                    guard let url = try? result.get(),
                          url.startAccessingSecurityScopedResource() else { return }
                    defer { url.stopAccessingSecurityScopedResource() }
                    guard let data = try? Data(contentsOf: url),
                          let dtos = try? JSONDecoder().decode([ItemDTO].self, from: data) else { return }
                    
                    var added = 0
                    var skipped = 0
                    for dto in dtos {
                        let isDuplicate = items.contains { dto.matches($0) }
                        if isDuplicate {
                            skipped += 1
                        } else {
                            let newItem = Item(
                                calories: dto.calories,
                                carbohydrates: dto.carbohydrates,
                                fat: dto.fat,
                                name: dto.name,
                                protein: dto.protein
                            )
                            modelContext.insert(newItem)
                            added += 1
                        }
                    }
                    importResult = ImportResult(added: added, skipped: skipped)
                    showImportAlert = true
                }
                .alert("Import Complete", isPresented: $showImportAlert) {
                    Button("OK") { }
                } message: {
                    if let r = importResult {
                        Text("\(r.added) items added, \(r.skipped) duplicates skipped.")
                    }
                }
        }
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
    let added: Int
    let skipped: Int
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
