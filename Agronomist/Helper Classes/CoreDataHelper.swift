//
//  CoreDataHelper.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static func save(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    static func addPlant(name: String, sunTolerance: SunTolarance, waterRequirementInterval: Int, waterRequirementUnit: WaterRequirementUnit, to context: NSManagedObjectContext, saveOnCompletion: Bool = true) {
        
        let plant = Plant(context: context)
        plant.id = UUID()
        plant.name = name
        plant.sun_tolerance = sunTolerance.rawValue
        plant.water_req_interval = Int64(waterRequirementInterval)
        plant.water_req_unit = waterRequirementUnit.rawValue
        
        if saveOnCompletion {
            save(context)
        }
    }
    
    static func updatePlant(_ plant: Plant, name: String, sunTolerance: SunTolarance, waterRequirementInterval: Int, waterRequirementUnit: WaterRequirementUnit, to context: NSManagedObjectContext, saveOnCompletion: Bool = true) {
        
        plant.name = name
        plant.sun_tolerance = sunTolerance.rawValue
        plant.water_req_interval = Int64(waterRequirementInterval)
        plant.water_req_unit = waterRequirementUnit.rawValue
        
        if saveOnCompletion {
            save(context)
        }
    }
    
    static func deletePlant(_ plant: Plant, from context: NSManagedObjectContext, saveOnCompletion: Bool = true) {
        context.delete(plant)
        
        if saveOnCompletion {
            save(context)
        }
        
    }
    
    static func addWaterLog(date: Date, to plant: Plant, in context: NSManagedObjectContext, saveOnCompletion: Bool = true) {
        let log = WaterLog(context: context)
        log.date = date
        
        plant.addToWaterLogs(log)
        
        if saveOnCompletion {
            save(context)
        }
    }
}
