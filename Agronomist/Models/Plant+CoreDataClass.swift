//
//  Plant+CoreDataClass.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/4/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Plant)
public class Plant: NSManagedObject {
    var wrappedName: String {
        return name ?? "NO_NAME"
    }
    
    var wrappedSunTolerance: String {
        return sun_tolerance ?? "NO_VALUE"
    }
    
    var wrapppedWaterRequirementInterval: Int {
        return Int(water_req_interval)
    }
    
    var wrapppedWaterRequirementCalendar: String {
        return water_req_calendar ?? "NO_VALUE"
    }
    
    var waterLogArray: [WaterLog] {
        let set = waterLogs as? Set<WaterLog> ?? []
        return set.sorted {
            $0.wrappedDate > $1.wrappedDate
        }
    }
}
