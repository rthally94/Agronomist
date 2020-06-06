//
//  PlantEditorForm.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantForm: View {
    @Environment(\.presentationMode) var presentationMode
    
    let defaultName: String = "Untitled \(Date())"
    let isEditing: Bool
    
    @State var name: String
    @State var sunTolerancePickerChoice: SunTolarance = .fullShade
    
    @State var waterRequirementPickerIsVisible: Bool = false
    @State var waterRequirementPickerUnitChoice: String
    @State var waterRequirementPickerIntervalChoice: Int
    
    var chosenInterval: DateComponents {
        switch waterRequirementPickerUnitChoice {
        case "day":
            return DateComponents(day: waterRequirementPickerIntervalChoice + 1)
        case "week":
            return DateComponents(day: (waterRequirementPickerIntervalChoice + 1) * 7)
        case "month":
            return DateComponents(month: waterRequirementPickerIntervalChoice + 1)
        case "year":
            return DateComponents(year: waterRequirementPickerIntervalChoice + 1)
        default:
            return DateComponents()
        }
    }
    
    let onDelete: () -> Void
    let onSave: (String, String, Date) -> Void
    
    init(onDelete: @escaping () -> Void, onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = onDelete
        self.onSave = onSave
        
        self.isEditing = false
        
        _name = State(initialValue: defaultName)
        _sunTolerancePickerChoice = State(initialValue: .fullShade)
        _waterRequirementPickerIntervalChoice = State(initialValue: 0)
        _waterRequirementPickerUnitChoice = State(initialValue: "day")
    }
    
    init(onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        self.isEditing = false
        
        _name = State(initialValue: defaultName)
        _sunTolerancePickerChoice = State(initialValue: .fullShade)
        _waterRequirementPickerIntervalChoice = State(initialValue: 0)
        _waterRequirementPickerUnitChoice = State(initialValue: "day")
    }
    
    init(plant: Plant, onDelete: @escaping () -> Void, onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = onDelete
        self.onSave = onSave
        
        isEditing = true
        
        let defName = defaultName
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: plant.wrappedSunTolerance)
        _waterRequirementPickerIntervalChoice = State(initialValue: plant.waterRequirementValue)
        _waterRequirementPickerUnitChoice = State(initialValue: plant.waterRequirementUnit)
    }
    
    init(plant: Plant, onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        isEditing = true
        
        let defName = defaultName
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: plant.wrappedSunTolerance)
        _waterRequirementPickerIntervalChoice = State(initialValue: plant.waterRequirementValue)
        _waterRequirementPickerUnitChoice = State(initialValue: plant.waterRequirementUnit)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Climate")) {
                    Picker("Light Value", selection: Binding(get: {self.sunTolerancePickerChoice}, set: { (res) in
                        self.sunTolerancePickerChoice = res
                        self.dismissKeyboard()
                    })) {
                        ForEach(sunTolerancePickerStates, id: \.self) { state in
                            VStack(alignment: .leading) {
                                Text(SunTolarance.formattedTitle(for: state))
                                Text(SunTolarance.description(for: state))
                                    .font(.caption)
                            }
                            .tag(state)
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Watering Frequency")
                            Spacer()
                            Text(currentWaterRequirementTextShort.capitalized).foregroundColor( waterRequirementPickerIsVisible ? .green : nil)
                        }
                        .onTapGesture {
                            self.dismissKeyboard()
                            self.waterRequirementPickerIsVisible.toggle()
                        }
                        
                        if waterRequirementPickerIsVisible {
                            Divider()
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Picker("Interval", selection: $waterRequirementPickerIntervalChoice) {
                                        ForEach(waterRequirementInterval) { index in
                                            Text("\(index)").tag(index)
                                        }
                                    }
                                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                                    .clipped()
                                    
                                    if waterRequirementPickerIntervalChoice == 0 {
                                        Picker("Calendar", selection: $waterRequirementPickerUnitChoice) {
                                            ForEach(waterRequirementUnits, id: \.self) { unit in
                                                Text(unit).tag(unit)
                                            }
                                        }
                                        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                                        .clipped()
                                    } else {
                                        Picker("Calendar", selection: $waterRequirementPickerUnitChoice) {
                                            ForEach(waterRequirementUnits, id: \.self) { unit in
                                                Text(unit.appending("s")).tag(unit)
                                            }
                                        }
                                        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                                        .clipped()
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(WheelPickerStyle())
                                
                                Text(currentWaterRequirementTextLong).font(.caption)
                            }
                        }
                    }
                }
                
                if isEditing {
                    Section {
                        Button("Delete Plant") {
                            self.onDelete()
                            self.dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("\(isEditing ? name : "New Plant")", displayMode: .inline)
            .navigationBarItems(
                leading:  Button(action: {self.dismiss()}) {
                    Text("Cancel").foregroundColor(.red)
                },
                trailing: Button("Save", action: {
                    self.onSave(
                        self.name == "" ? self.defaultName : self.name,
                        self.sunTolerancePickerChoice.rawValue,
                        self.chosenInterval.date ?? Date()
                    )
                    
                    self.dismiss()
                })
            )
        }
    }
    
    // MARK: Intents
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: Exposed Properties
    
    var waterRequirementCalendarPicker: [String] {
        return waterRequirementUnits
    }
    
    var waterRequirementIntervalPicker: [String] {
        return waterRequirementInterval.map{"\($0)".capitalized}
    }
    
    var currentWaterRequirementTextLong: String {
        return "Watering reminder will be \(currentWaterRequirementTextShort)."
    }
    
    var currentWaterRequirementTextShort: String {
        switch waterRequirementPickerUnitChoice {
        case "week":
            let relative = relativeDateFormatter.localizedString(from: chosenInterval).replacingOccurrences(of: "day", with: "week").replacingOccurrences(of: "in", with: "every").split(separator: " ")
            let interval = Int(String(relative[1])) ?? 7
            return "\(relative[0]) \(interval / 7 ) \(relative[2])"
            
        default:
            return relativeDateFormatter.localizedString(from: chosenInterval).replacingOccurrences(of: "in", with: "every")
        }
    }
    
    private var relativeDateFormatter: RelativeDateTimeFormatter = {
        let rdtf = RelativeDateTimeFormatter()
        
        rdtf.dateTimeStyle = .numeric
        
        return rdtf
    }()
    
    // MARK: Picker Constants
    private var sunTolerancePickerStates: [SunTolarance] {
        return SunTolarance.allCases
    }
    
    private let waterRequirementUnits: [String] = [
        "day",
        "week",
        "month",
        "year"
    ]
    
    private let waterRequirementInterval = 1..<1000
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        PlantForm { _, _, _ in
            
        }
    }
}
