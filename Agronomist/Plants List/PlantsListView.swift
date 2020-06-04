//
//  PlantsListView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantsListView: View {
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.name, ascending: true)]) var plants: FetchedResults<Plant>
    @Environment(\.managedObjectContext) var moc
    
    @State var showAddPlantForm: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                List(plants, id: \.id ) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        PlantsListRowView(plant: plant)
                    }
                }
                .listStyle(GroupedListStyle())
                
                Button(action: {self.showAddPlantForm = true}, label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Plant") }
                )
                    .padding()
                    .sheet(isPresented: $showAddPlantForm, onDismiss: {self.showAddPlantForm = false}) {
                        PlantForm { name, sun, water_int, water_cal in
                            let newPlant = Plant(context: self.moc)
                            newPlant.id = UUID()
                            newPlant.name = name
                            newPlant.sun_tolerance = sun
                            newPlant.water_req_calendar = water_cal
                            newPlant.water_req_interval = Int32(water_int)
                            
                            self.saveContext()
                        }
                }
            }
            .navigationBarTitle("Plants")
        }
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

struct PlantsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsListView()
    }
}
