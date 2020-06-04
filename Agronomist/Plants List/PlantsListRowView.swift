//
//  PlantListRowView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsListRowView: View {
    @ObservedObject var plant: Plant
    
    var name: String {
        return plant.name ?? "NO_NAME"
    }
    
    var body: some View {
        Text(name)
    }
}

struct PlantListRowView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var moc
    @FetchRequest(sortDescriptors: []) static var plants: FetchedResults<Plant>
    
    static var previews: some View {
        PlantsListRowView(plant: plants[0])
    }
}
