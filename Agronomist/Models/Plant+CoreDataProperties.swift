//
//  Plant+CoreDataProperties.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/4/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sun_tolerance: String?
    @NSManaged public var water_req_interval: Int32
    @NSManaged public var water_req_calendar: String?
    @NSManaged public var waterLogs: NSSet?

}

// MARK: Generated accessors for waterLogs
extension Plant {

    @objc(addWaterLogsObject:)
    @NSManaged public func addToWaterLogs(_ value: WaterLog)

    @objc(removeWaterLogsObject:)
    @NSManaged public func removeFromWaterLogs(_ value: WaterLog)

    @objc(addWaterLogs:)
    @NSManaged public func addToWaterLogs(_ values: NSSet)

    @objc(removeWaterLogs:)
    @NSManaged public func removeFromWaterLogs(_ values: NSSet)

}
