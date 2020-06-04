//
//  EditPlantView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/2/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct EditPlantView: View {
    var plant: Plant
    
    var body: some View {
        NavigationView {
            PlantEditorForm(plant: plant)
                .navigationBarTitle("Edit", displayMode: .inline)
        }
    }
}

struct EditPlantView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: moc)
        plant.id = UUID()
        plant.name = "NEW_PLANT"
        
        return EditPlantView(plant: plant).environment(\.managedObjectContext, moc)
    }
}
