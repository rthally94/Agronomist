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
    
    @State var wateredPlants = [Plant]()
    
    var mergedPlantLists: [Plant] {
        return (plantsNeedingWater + wateredPlants).sorted(by: {$0.wrappedName < $1.wrappedName})
    }
    
    var plantWateringHeaderString: String {
        if plantsNeedingWater.count == 1 {
            return "\(plantsNeedingWater.count) plant needs watering today."
        } else {
            return "\(plantsNeedingWater.count) plants need watering today."
        }
    }
    
    @State var tableIsVisible: Bool = false
    private var listPlaceHolderIsVisible: Bool {
        return mergedPlantLists.count == 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !listPlaceHolderIsVisible {
                    SectionView(label: plantWateringHeaderString) {
                        ScrollView {
                            ForEach(mergedPlantLists, id: \Plant.name) { plant in
                                PlantTodayViewListRow(plant: plant) { isMarked in
                                    if isMarked {
                                        self.wateredPlants.append(plant)
                                        CoreDataHelper.addWaterLog(date: Date(), to: plant, in: self.moc)
                                    } else {
                                        if let index = self.wateredPlants.firstIndex(of: plant) {
                                            self.wateredPlants.remove(at: index)
                                        }
                                        
                                        if let log = plant.waterLogArray.first {
                                            CoreDataHelper.deleteWaterLog(log, from: plant, in: self.moc)
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                }
                
                if listPlaceHolderIsVisible {
                    ZStack {
                        CardView {
                            VStack {
                                Image(systemName: "checkmark.circle.fill").font(.largeTitle)
                                Text("All Set!").font(.largeTitle)
                                Text("No plants need watering today")
                            }
                        }
                        .foregroundColor(.blue)
                        .padding()
                    }
                    .transition(AnyTransition.scale.animation(.spring()))
                }
            }
            .onAppear {
                self.wateredPlants.removeAll()
            }
            .navigationBarTitle("Today")
            .navigationBarHidden(listPlaceHolderIsVisible)
        }
    }
}

struct PlantWateringTodayView_Previews: PreviewProvider {
    static var previews: some View {
        return PlantWateringTodayView()
    }
}
