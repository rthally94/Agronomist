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
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                plant.name.map(Text.init)
                
            }
            
            Section(header: Text("Growing Conditions")) {
                VStack(alignment: .leading) {
                    Text("Sun Tolerance").font(.caption)
                    plant.sun_tolerance.map(formatForDisplay).map(Text.init)
                }
                
                VStack(alignment: .leading) {
                    Text("Water Requirements").font(.caption)
                    HStack {
                        Text("\(plant.water_req_interval)")
                        plant.water_req_calendar.map(formatForDisplay).map(Text.init)
                    }
                }
            }
        }
        .sheet(
            isPresented: $editMode,
            onDismiss: {
                self.editMode = false
        }) {
            PlantForm(plant: self.plant, onDelete: { self.deletePlant() }) { name, sun, water_int, water_cal in
                self.plant.name = name
                self.plant.sun_tolerance = sun
                self.plant.water_req_interval = Int32(water_int)
                self.plant.water_req_calendar = water_cal
                
                self.saveContext()
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("\(plant.name ?? "NO_NAME")", displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {self.editMode = true} )
    }
    
    func formatForDisplay(_ input: String) -> String {
        return input.replacingOccurrences(of: "|", with: " ").replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    // MARK: Intents
    
    private func deletePlant() {
        print("Delete Pressed")
        moc.delete(plant)
        self.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Cannot save context: \(error)")
            }
        }
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
