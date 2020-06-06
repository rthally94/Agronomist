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
    
    var chosenInterval: DateComponents {
        switch waterRequirementCalendarPickerStates[waterRequirementPickerCalendarChoice] {
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
        _sunTolerancePickerChoice = State(initialValue: 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: 0)
        _waterRequirementPickerCalendarChoice = State(initialValue: 0)
    }
    
    init(onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        self.isEditing = false
        
        _name = State(initialValue: defaultName)
        _sunTolerancePickerChoice = State(initialValue: 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: 0)
        _waterRequirementPickerCalendarChoice = State(initialValue: 0)
    }
    
    init(plant: Plant, onDelete: @escaping () -> Void, onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = onDelete
        self.onSave = onSave
        
        isEditing = true
        
        let defName = defaultName
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: sunTolarancePickerStates.firstIndex(where: {$0.storedName == plant.sun_tolerance}) ?? 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: plant.waterRequirementValue)
        _waterRequirementPickerCalendarChoice = State(initialValue: waterRequirementCalendarPickerStates.firstIndex(of: plant.waterRequirementUnit) ?? 0)
    }
    
    init(plant: Plant, onSave: @escaping (String, String, Date) -> Void) {
        self.onDelete = {}
        self.onSave = onSave
        
        isEditing = true
        
        let defName = defaultName
        _name = State(initialValue: plant.name ?? defName)
        _sunTolerancePickerChoice = State(initialValue: sunTolarancePickerStates.firstIndex(where: {$0.storedName == plant.sun_tolerance}) ?? 0)
        _waterRequirementPickerIntervalChoice = State(initialValue: plant.waterRequirementValue)
        _waterRequirementPickerCalendarChoice = State(initialValue: waterRequirementCalendarPickerStates.firstIndex(of: plant.waterRequirementUnit) ?? 0)
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
                                    
                                    Picker("Calendar", selection: $waterRequirementPickerCalendarChoice) {
                                        ForEach(0..<waterRequirementCalendarPicker.count) { index in
                                            Text(self.waterRequirementCalendarPicker[index]).tag(index)
                                        }
                                    }
                                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                                    .clipped()
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
                        self.sunTolarancePickerStates[self.sunTolerancePickerChoice].storedName,
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
    var sunTolarancePicker: [(name: String, description: String)] {
        return sunTolarancePickerStates.map { ($0.storedName.capitalized, $0.description.capitalized) }
    }
    
    // TODO: Updated pluralization not being pushed on number chnage. Needs a forced refresh to appear.
    var waterRequirementCalendarPicker: [String] {
        return waterRequirementCalendarPickerStates
    }
    
    var waterRequirementIntervalPicker: [String] {
        return waterRequirementInterval.map{"\($0)".capitalized}
    }
    
    var currentWaterRequirementTextLong: String {
        return "Watering reminder will be \(currentWaterRequirementTextShort)."
    }
    
    var currentWaterRequirementTextShort: String {
        switch waterRequirementCalendarPickerStates[waterRequirementPickerCalendarChoice] {
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
        PlantForm { _, _, _ in
            
        }
    }
}
