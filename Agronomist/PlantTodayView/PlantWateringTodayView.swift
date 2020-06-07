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
    @Environment(\.managedObjectContext) var moc
    
    var plantsNeedingWater: [Plant] {
        return plants.filter { plant in
            return plant.wateringIsNeeded
        }
    }
    
    var plantWateringHeaderString: String {
        if plantsNeedingWater.count == 1 {
            return "\(plantsNeedingWater.count) plant needs watering today."
        } else {
            return "\(plantsNeedingWater.count) plants need watering today."
        }
    }
    
    @State var tableIsVisible: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if plantsNeedingWater.count > 0 {
                        Section(header: Text(plantWateringHeaderString).font(.body).fontWeight(.semibold)) {
                            ForEach(plantsNeedingWater, id: \.name) { plant in
                                PlantTodayViewListRow(plant: plant) {
                                    CoreDataHelper.addWaterLog(date: Date(), to: plant, in: self.moc)
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                if plantsNeedingWater.count == 0 {
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
                    .transition(.scale)
                }
            }
            .navigationBarTitle("Today")
        }
    }
}

struct PlantWateringTodayView_Previews: PreviewProvider {
    static var previews: some View {
        return PlantWateringTodayView()
    }
}
