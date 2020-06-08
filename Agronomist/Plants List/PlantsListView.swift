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
    @State private var showDeleteAlert: Bool = false
    @State private var indexSetToDelete: IndexSet?
    
    
    var plantNames: [String] {
        return plants.map{$0.wrappedName}
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                if plants.count > 0 {
                    List {
                        ForEach(plants, id: \.id) { plant in
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                PlantsListRowView(plant: plant)
                                    .padding(.vertical, 5)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(GroupedListStyle())
                    .alert(isPresented: $showDeleteAlert, content: {
                        Alert(title: Text("Are you sure?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete"), action: {
                            if let index = self.indexSetToDelete?.first {
                                let plant = self.plants[index]
                                CoreDataHelper.deletePlant(plant, from: self.moc)
                            }
                        }), secondaryButton: .cancel())
                    })
                    
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
                        .transition(AnyTransition.scale.animation(.spring()))
                }
            }
            .navigationBarHidden(plants.count == 0)
            .navigationBarTitle("Your Plants")
            .sheet(isPresented: $showAddPlantForm, onDismiss: {self.showAddPlantForm = false}) {
                PlantForm { name, sun, water_int, water_unit in
                    CoreDataHelper.addPlant(name: name, sunTolerance: sun, waterRequirementInterval: water_int, waterRequirementUnit: water_unit, to: self.moc)
                }
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        indexSetToDelete = offsets
        showDeleteAlert = true
    }
}

struct PlantsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsListView()
    }
}
