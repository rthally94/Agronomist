//
//  PlantsListView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsListView: View {
    @ObservedObject var plantListVM: PlantListViewModel
    
    init() {
        plantListVM = PlantListViewModel()
    }
    
    @State var showAddPlantForm: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                List(plantListVM.plants, id: \.name ) { plant in
//                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        PlantsListRowView(plantListRowVM: plant)
//                    }
                }
                .listStyle(GroupedListStyle())
                
                Button(action: {self.showAddPlantForm = true}, label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Plant") }
                )
                    .padding()
                    .sheet(isPresented: $showAddPlantForm, onDismiss: {self.showAddPlantForm = false}) {
                        NewPlantView()
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
