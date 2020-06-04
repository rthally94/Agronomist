//
//  PlantListRowView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantsListRowView: View {
    @ObservedObject var plantListRowVM: PlantListRowViewModel
    
    var body: some View {
        Text(plantListRowVM.name)
    }
}

struct PlantListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: moc)
        plant.id = UUID()
        plant.name = "My New Plant"
        plant.sun_tolerance = "part_shade"
        plant.water_interval = ""
        plant.water_interval_period = ""
        
        return PlantsListRowView(plantListRowVM: .init(plant: plant))
    }
}
