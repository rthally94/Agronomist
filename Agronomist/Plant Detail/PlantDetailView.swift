//
//  PlantDetailView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var plant: Plant
    @State var editMode: Bool = false
    
    var name: String {
        return plant.name ?? "NO_NAME"
    }
    
    var uuid: String {
        if let id = plant.id {
            return "\(id)"
        } else {
            return "NO_ID"
        }
    }
    
    var sunTolaranceText: String {
        let value = plant.sun_tolerance ?? "NO_VALUE"
        return value.capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    var waterFrequencyText: String {
        let value = plant.water_interval ?? "NO_VALUE"
        let parts = value.split(separator: "|")
        return value.capitalized.replacingOccurrences(of: "|", with: " ") + "\(Int(parts[0]) ?? 0 > 1 ? "s" : "")"
    }
    
    var body: some View {
        List {
            Section {
                Text(name)
            }
            
            Section {
                Text(sunTolaranceText)
                Text(waterFrequencyText)
            }
        }
        .sheet(
            isPresented: $editMode,
            onDismiss: {
                self.editMode = false
                if self.plant.name == nil {
                    self.presentationMode.wrappedValue.dismiss()
                }
        }) {
            EditPlantView(plant: self.plant).environment(\.managedObjectContext, self.moc)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("\(name)", displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {self.editMode = true} )
    }
    
    private func deleteAction() {
        print("Delete Pressed")
        moc.delete(plant)
        presentationMode.wrappedValue.dismiss()
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let plant = Plant(context: moc)
        plant.id = UUID()
        plant.name = "Test Plant"
        
        return PlantDetailView(plant: plant)
    }
}
