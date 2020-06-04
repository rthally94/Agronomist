//
//  PlantsListView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.name, ascending: true)]) var plants: FetchedResults<Plant>
    
    @State var showAddPlantForm: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                List(plants, id: \.id) { plant in
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
                        NewPlantView().environment(\.managedObjectContext, self.moc)
                }
                    
            }
            .navigationBarTitle("Plants")
        }
    }
}

struct PlantsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsListView()
    }
}
