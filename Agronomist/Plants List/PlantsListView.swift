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
    
    @State private var showAddPlantForm: Bool = false
    
    var plantNames: [String] {
        return plants.map{$0.wrappedName}
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                if plants.count > 0 {
                    List(plants, id: \.id) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            PlantsListRowView(plant: plant)
                                .padding(.vertical, 5)
                        }
                    }
                    .listStyle(GroupedListStyle())
                    
                    Button(
                        action: {
                            self.showAddPlantForm = true
                    },
                        label: {
                        Image(systemName: "plus.circle.fill").font(.title)
                        Text("Add Plant").fontWeight(.semibold)
                    })
                    .padding()
                } else {
                    Button(
                        action: {
                            self.showAddPlantForm = true
                    },
                        label: {
                            CardView() {
                                VStack {
                                    Image(systemName: "plus.circle.fill").font(.largeTitle)
                                    Text("Nothing Planted").font(.largeTitle)
                                    Text("Let's grow something new").font(.body)
                                }
                            }
                            .padding()
                            .foregroundColor(.green)
                    })
                }
            }
            .navigationBarHidden(plants.count == 0)
            .navigationBarTitle("Plants")
            .sheet(isPresented: $showAddPlantForm, onDismiss: {self.showAddPlantForm = false}) {
                PlantForm { name, sun, water_int, water_unit in
                    CoreDataHelper.addPlant(name: name, sunTolerance: sun, waterRequirementInterval: water_int, waterRequirementUnit: water_unit, to: self.moc)
                }
            }
        }
    }
}

struct PlantsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsListView()
    }
}
