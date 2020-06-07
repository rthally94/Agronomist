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
    @Environment(\.presentationMode) private var presentationMode
    
    var isEditing: Bool = false
    
    @State var name: String = ""
    @State var sunTolerancePickerChoice: SunTolarance = .fullShade
    
    @State private var waterRequirementPickerIsVisible: Bool = false
    @State var waterRequirementPickerIntervalChoice: Int = 1
    @State var waterRequirementPickerUnitChoice: WaterRequirementUnit = .day
    
    var onDelete: () -> Void = {}
    var onSave: (String, SunTolarance, Int, WaterRequirementUnit) -> Void = { _, _, _, _ in }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    TextField("Name", text: Binding(get: {self.name}, set: { (val) in self.name = val.capitalized}))
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
    
    private var wateringForm: some View {
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
    
    private var waterRequirementCalendarPicker: [String] {
        return waterRequirementUnits
    }
    
    private var waterRequirementIntervalPicker: [String] {
        return waterRequirementInterval.map{"\($0)".capitalized}
    }
    
    private var currentWaterRequirementTextLong: String {
        return "Watering reminder will be \(currentWaterRequirementTextShort)."
    }
    
    private var currentWaterRequirementTextShort: String {
        return "every \(waterRequirementPickerIntervalChoice) \(waterRequirementPickerUnitChoice.rawValue)".appending(waterRequirementPickerIntervalChoice != 1 ? "s" : "")
    }
    
    private let relativeDateFormatter: RelativeDateTimeFormatter = {
        let rdtf = RelativeDateTimeFormatter()
        
        rdtf.dateTimeStyle = .numeric
        
        return rdtf
    }()
    
    private let dateFormatter: DateFormatter = {
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
        PlantForm()
    }
}

extension PlantForm {
    init(plant: Plant, onDelete: @escaping () -> Void, onSave: @escaping (String, SunTolarance, Int, WaterRequirementUnit) -> Void) {
        self.init(name: plant.wrappedName, sunTolerancePickerChoice: plant.wrappedSunTolerance, waterRequirementPickerIntervalChoice: plant.wrapppedWaterRequirementInterval, waterRequirementPickerUnitChoice: plant.wrappedWaterRequirementUnit, onDelete: onDelete, onSave: onSave)
        
        self.isEditing = true
    }
}
