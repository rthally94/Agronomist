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
    @State var sunTolerancePickerChoice: Int
    @State var waterRequirementPickerIsVisible: Bool = false
    @State var waterRequirementPickerCalendarChoice: Int
    @State var waterRequirementPickerIntervalChoice: Int
    
    let onDelete: () -> Void
    let onSave: (String, String, Int, String) -> Void
    
    init(onDelete: @escaping () -> Void, onSave: @escaping (String, String, Int, String) -> Void) {
        self.isEditing = false
        self.onDelete = onDelete
        self.onSave = onSave
        
        _name = State(initialValue: defaultName)
        _sunTolerancePickerChoice = State(initialValue: 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: 0)
        _waterRequirementPickerCalendarChoice = State(initialValue: 0)
    }
    
    init(onSave: @escaping (String, String, Int, String) -> Void) {
        self.isEditing = false
        self.onDelete = {}
        self.onSave = onSave
        
        _name = State(initialValue: defaultName)
        _sunTolerancePickerChoice = State(initialValue: 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: 0)
        _waterRequirementPickerCalendarChoice = State(initialValue: 0)
    }
    
    init(plant: Plant, onDelete: @escaping () -> Void, onSave: @escaping (String, String, Int, String) -> Void) {
        self.onDelete = onDelete
        self.onSave = onSave
        
        isEditing = true
        
        let defName = defaultName
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: sunTolarancePickerStates.firstIndex(where: {$0.storedName == plant.sun_tolerance}) ?? 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: Int(plant.water_req_interval - 1))
        _waterRequirementPickerCalendarChoice = State(initialValue: waterRequirementCalendarPickerStates.firstIndex(of: plant.water_req_calendar ?? "") ?? 0)
    }
    
    init(plant: Plant, onSave: @escaping (String, String, Int, String) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        isEditing = true
        let defName = defaultName
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: sunTolarancePickerStates.firstIndex(where: {$0.storedName == plant.sun_tolerance}) ?? 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: Int(plant.water_req_interval - 1))
        _waterRequirementPickerCalendarChoice = State(initialValue: waterRequirementCalendarPickerStates.firstIndex(of: plant.water_req_calendar ?? "") ?? 0)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Climate")) {
                    Picker("Light Value", selection: $sunTolerancePickerChoice) {
                        ForEach(0..<sunTolarancePickerStates.count, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text(self.sunTolarancePickerStates[index].storedName)
                                Text(self.sunTolarancePickerStates[index].description)
                                    .font(.caption)
                            }
                            .tag(index)
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Watering Frequency")
                            Spacer()
                            Text("Every \(currentWaterRequirementTextShort)").foregroundColor( waterRequirementPickerIsVisible ? .red : nil)
                        }
                        .onTapGesture {
                            self.waterRequirementPickerIsVisible.toggle()
                        }
                        
                        if waterRequirementPickerIsVisible {
                            HStack {
                                Picker("", selection: $waterRequirementPickerIntervalChoice) {
                                    ForEach(waterRequirementInterval) { index in
                                        Text(self.formatForDisplay(index)).tag(index)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                                
                                Picker("", selection: $waterRequirementPickerCalendarChoice) {
                                    ForEach(0..<waterRequirementCalendarPickerStates.count) { index in
                                        Text(self.waterRequirementCalendarPickerStates[index]).tag(index)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                            }
                            Text(currentWaterRequirementTextLong).font(.caption)
                        }
                    }
                }
                
                Section {
                    Button("Delete Plant") {
                        self.onDelete()
                        self.dismiss()
                    }
                    .foregroundColor(.red)
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
                        self.sunTolarancePickerStates[self.sunTolerancePickerChoice].storedName,
                        self.waterRequirementPickerIntervalChoice + 1,
                        self.waterRequirementCalendarPickerStates[self.waterRequirementPickerCalendarChoice]
                    )
                    
                    self.dismiss()
                })
            )
        }
    }
    
    // MARK: Intents
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: Exposed Properties
    var sunTolarancePicker: [(name: String, description: String)] {
        return sunTolarancePickerStates.map { (formatForDisplay($0.storedName), formatForDisplay($0.description)) }
    }
    
    var waterRequirementCalendarPicker: [String] {
        return waterRequirementCalendarPickerStates.map(formatForDisplay)
    }
    
    var waterRequirementIntervalPicker: [String] {
        return waterRequirementInterval.map{ formatForDisplay("\($0)")}
    }
    
    var currentWaterRequirementTextLong: String {
        return "Watering reminder will be every \(currentWaterRequirementTextShort)."
    }
    
    var currentWaterRequirementTextShort: String {
        return "\(waterRequirementIntervalPicker[waterRequirementPickerIntervalChoice]) \(waterRequirementCalendarPicker[waterRequirementPickerCalendarChoice])"
    }
    
    func formatForDisplay(_ input: String) -> String {
        return input.replacingOccurrences(of: "|", with: " ").replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    func formatForDisplay(_ input: Int) -> String {
        return formatForDisplay(String(input))
    }
    
    // MARK: Picker Constants
    
    private let sunTolarancePickerStates: [(storedName: String, description: String)] = [
        ("full_shade", "1 hour of direct sun"),
        ("partial_shade", "2 hours of direct sun"),
        ("light_shade", "3-5 hours of direct sun"),
        ("full_sun", "6+ hours of direct sun")
    ]
    
    private let waterRequirementCalendarPickerStates: [String] = [
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
