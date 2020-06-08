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
    @ObservedObject var plant: Plant
    
    var lastLoggedString: String {
        return Formatter.nextWateringText(for: plant)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(plant.wrappedName).font(.headline)
            Spacer()
            Text(lastLoggedString).font(.subheadline)
        }
    }
}

struct PlantListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: moc)
        plant.id = UUID()
        plant.name = "My New Plant"
        plant.sun_tolerance = "part_shade"
        plant.water_req_interval = 1
        plant.water_req_unit = "day"
        
        return PlantsListRowView(plant: plant)
    }
}
