//
//  PlantEditorForm.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantEditorForm: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var plant: Plant
    var isEditing: Bool
    
    @State var titleText: String = ""
    
    @State var sunTolaranceChoice: Int = 0
    private let sunTolaranceStates: [(name: String, description: String)] = [
        ("full_shade", "1 hour of direct sun"),
        ("partial_shade", "2 hours of direct sun"),
        ("light_shade", "3-5 hours of direct sun"),
        ("full_sun", "6+ hours of direct sun")
    ]
    
    @State var waterRequirementPickerIsVisible: Bool = false
    @State var waterRequirementFrequency: Int = 0
    private let waterRequirementFrequencyStates: [String] = [
        "day",
        "week",
        "month",
        "year"
    ]
    
    @State var waterRequirementInterval: Int = 0
    private let waterRequirementIntervalStates: [String] = Array(1...1000).map { "\($0)" }
    
    private var requirementTextLong: String {
        return "Watering reminder will be every \(requirementTextShort)."
    }
    
    private var requirementTextShort: String {
        return "\(waterRequirementInterval + 1) \(requirementTextFormatter(waterRequirementFrequencyStates[waterRequirementFrequency]))"
    }
    
    private func requirementTextFormatter(_ input: String) -> String {
        return input.capitalized + "\(waterRequirementInterval == 0 ? "" : "s")"
    }
    
    init(plant: Plant? = nil) {
        isEditing =  plant != nil
        self.plant = plant ?? Plant(context: .init(concurrencyType: .mainQueueConcurrencyType))
    }
    
    var body: some View {
        Form {
            Section(header: Text("General")) {
                TextField("Name", text: $titleText)
            }
            
            Section(header: Text("Climate")) {
                Picker("Light Value", selection: $sunTolaranceChoice) {
                    ForEach(0..<sunTolaranceStates.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(self.sunTolaranceStates[index].name.capitalized.replacingOccurrences(of: "_", with: " "))
                            Text(self.sunTolaranceStates[index].description).font(.caption)
                        }
                        .tag(index)
                    }
                }
            
                HStack {
                    Text("Watering Frequency")
                    Spacer()
                    Text("Every \(requirementTextShort)").foregroundColor( waterRequirementPickerIsVisible ? .red : nil)
                }
                .onTapGesture {
                    self.waterRequirementPickerIsVisible.toggle()
                }
                
                if waterRequirementPickerIsVisible {
                    VStack(alignment: .leading) {
                        HStack {
                            Picker("", selection: $waterRequirementInterval) {
                                ForEach(0..<waterRequirementIntervalStates.count) { index in
                                    Text(self.waterRequirementIntervalStates[index])
                                        .tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                            
                            Picker("", selection: $waterRequirementFrequency) {
                                ForEach(0..<waterRequirementFrequencyStates.count) { index in
                                    Text(self.requirementTextFormatter(self.waterRequirementFrequencyStates[index])).tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                        }
                        Text(requirementTextLong).font(.caption)
                    }
                }
            }
            
            if isEditing {
                Button(action: {self.deletePlant()}) {
                    Text("Delete Plant").foregroundColor(.red)
                }
            }
        }
        .navigationBarItems(
            leading:  Button(action: {self.dismiss()}) {
                Text("Cancel").foregroundColor(.red)
            },
            trailing: Button("Save", action: {self.savePlant()})
        )
    }
    
    private func deletePlant() {
        moc.delete(self.plant)
        
        saveContext()
        dismiss()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func savePlant() {
        if !self.isEditing {
            self.moc.insert(self.plant)
        }
        
        plant.name = titleText
        plant.sun_tolerance = "\(sunTolaranceStates[sunTolaranceChoice].name)"
        plant.water_interval = waterRequirementFrequencyStates[waterRequirementFrequency]
        plant.water_interval_period = waterRequirementIntervalStates[waterRequirementInterval]
        
        saveContext()
        dismiss()
    }
    
    private func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Could not save: \(error)")
            }
        }
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        PlantEditorForm()
    }
}
