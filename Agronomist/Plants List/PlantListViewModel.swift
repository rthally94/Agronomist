//
//  PlantListViewModel.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/3/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class PlantListViewModel: ObservableObject {
    @Published var plants = [PlantListRowViewModel]()
    
    func fetchAllPlants() {
        self.plants = CoreDataService.shared.fetchAllPlants().map( PlantListRowViewModel.init )
    }
}

class PlantListRowViewModel: ObservableObject {
    var name: String = ""
    
    init(plant: Plant) {
        self.name = plant.name ?? "NO_NAME"
    }
}
