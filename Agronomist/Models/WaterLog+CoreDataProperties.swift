//
//  WaterLog+CoreDataProperties.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/4/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//
//

import Foundation
import CoreData


extension WaterLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterLog> {
        return NSFetchRequest<WaterLog>(entityName: "WaterLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var plant: Plant?

}
