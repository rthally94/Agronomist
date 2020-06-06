//
//  PlantWateringTodayView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantWateringTodayView: View {
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.name, ascending: true)]) var plants: FetchedResults<Plant>
    
    var plantsNeedingWater: [Plant] {
        return plants.filter { plant in
            return plant.wateringIsNeeded
        }
    }
    
    @ViewBuilder
    var body: some View {
        if plantsNeedingWater.count > 0 {
            List {
                Section(header: Text("Needs Water")) {
                    ForEach(plantsNeedingWater, id: \.name) { plant in
                        PlantTodayViewListRow(plant: plant)
                    }
                }
            }
            .listStyle(GroupedListStyle())
        } else {
            VStack {
                CardView {
                    VStack {
                        Image(systemName: "checkmark.circle.fill").font(.largeTitle)
                        Text("All Set!").font(.largeTitle)
                        Text("No plants need watering")
                    }
                }
                .foregroundColor(.blue)
                .padding()
            }
        }
    }
}

struct PlantWateringTodayView_Previews: PreviewProvider {
    static var previews: some View {
        return PlantWateringTodayView()
    }
}
