//
//  CoreDataService.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/3/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {
    static let shared = (CoreDataService(moc: NSManagedObjectContext.current))
    
    var moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchAllPlants() -> [Plant] {
        var plants = [Plant]()
        let plantsRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        
        do {
            plants = try self.moc.fetch(plantsRequest)
        } catch {
            print(error)
        }
        
        return plants
    }
    
}

extension NSManagedObjectContext {
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
