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
    
    let isEditing: Bool
    
    @State var name: String
    @State var sunTolerancePickerChoice: SunTolarance = .fullShade
    
    @State var waterRequirementPickerIsVisible: Bool = false
    @State var waterRequirementPickerIntervalChoice: Int
    @State var waterRequirementPickerUnitChoice: WaterRequirementUnit
    
    let onDelete: () -> Void
    let onSave: (String, SunTolarance, Int, WaterRequirementUnit) -> Void
    
    // MARK: Initializers
    
    init(onDelete: @escaping () -> Void, onSave: @escaping (String, SunTolarance, Int, WaterRequirementUnit) -> Void) {
        self.onDelete = onDelete
        self.onSave = onSave
        
        self.isEditing = false
        
        _name = State(initialValue: "")
        _sunTolerancePickerChoice = State(initialValue: .fullShade)
        _waterRequirementPickerIntervalChoice = State(initialValue: 1)
        _waterRequirementPickerUnitChoice = State(initialValue: .day)
    }
    
    init(onSave: @escaping (String, SunTolarance, Int, WaterRequirementUnit) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        self.isEditing = false
        
        _name = State(initialValue: "")
        _sunTolerancePickerChoice = State(initialValue: .fullShade)
        _waterRequirementPickerIntervalChoice = State(initialValue: 1)
        _waterRequirementPickerUnitChoice = State(initialValue: .day)
    }
    
    init(plant: Plant, onDelete: @escaping () -> Void, onSave: @escaping (String, SunTolarance, Int, WaterRequirementUnit) -> Void) {
        self.onDelete = onDelete
        self.onSave = onSave
        
        isEditing = true
        
        let defName = ""
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: plant.wrappedSunTolerance)
        _waterRequirementPickerIntervalChoice = State(initialValue: plant.wrapppedWaterRequirementInterval)
        _waterRequirementPickerUnitChoice = State(initialValue: plant.wrappedWaterRequirementUnit)
    }
    
    init(plant: Plant, onSave: @escaping (String, SunTolarance, Int, WaterRequirementUnit) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        isEditing = true
        
        let defName = ""
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: plant.wrappedSunTolerance)
        _waterRequirementPickerIntervalChoice = State(initialValue: plant.wrapppedWaterRequirementInterval)
        _waterRequirementPickerUnitChoice = State(initialValue: plant.wrappedWaterRequirementUnit)
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
                            
                            wateringForm
                            
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
                        self.name == "" ? "Plant \(self.dateFormatter.string(from: Date()))" : self.name,
                        self.sunTolerancePickerChoice,
                        self.waterRequirementPickerIntervalChoice,
                        self.waterRequirementPickerUnitChoice
                    )
                    
                    self.dismiss()
                })
                    .foregroundColor(.green)
            )
        }
    }
    
    var wateringForm: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker("Interval", selection: Binding(
                    get: {self.waterRequirementPickerIntervalChoice - 1},
                    set: { (val) in
                        self.waterRequirementPickerIntervalChoice = val + 1
                        print(val)
                }
                    ))
                {
                    ForEach(waterRequirementInterval) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                .clipped()
                
                if waterRequirementPickerIntervalChoice == 1 {
                    Picker("Calendar", selection: $waterRequirementPickerUnitChoice)
                    {
                        ForEach(WaterRequirementUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                    .clipped()
                } else {
                    Picker("Calendar", selection: $waterRequirementPickerUnitChoice) {
                        ForEach(WaterRequirementUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue.appending("s")).tag(unit)
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
        return "every \(waterRequirementPickerIntervalChoice) \(waterRequirementPickerUnitChoice.rawValue)".appending(waterRequirementPickerIntervalChoice != 1 ? "s" : "")
    }
    
    private var relativeDateFormatter: RelativeDateTimeFormatter = {
        let rdtf = RelativeDateTimeFormatter()
        
        rdtf.dateTimeStyle = .numeric
        
        return rdtf
    }()
    
    private var dateFormatter: DateFormatter = {
        let dcf = DateFormatter()
        
        dcf.dateStyle = .short
        dcf.timeStyle = .short
        
        return dcf
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
        PlantForm { _, _, _, _ in
            
        }
    }
}
