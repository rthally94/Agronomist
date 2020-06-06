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
    
    var wrappedSunTolerance: SunTolarance {
        return SunTolarance.init(rawValue: sun_tolerance ?? "") ?? SunTolarance.fullShade
    }
    
    var wrapppedWaterRequirementInterval: Date {
        return water_req_interval ?? Date()
    }
    
    var waterRequirementValue: Int {
        let cal = Calendar(identifier: .iso8601)
        let components = cal.dateComponents([.year, .month, . day], from: wrapppedWaterRequirementInterval)
        
        if let year = components.year, year > 0 {
            return year
        } else if let month = components.month, month > 0 {
            return month
        } else if let day = components.day, day > 0 {
            return day
        } else {
            return 0
        }
    }
    
    var waterRequirementUnit: String {
        let cal = Calendar(identifier: .iso8601)
        let components = cal.dateComponents([.year, .month, . day], from: wrapppedWaterRequirementInterval)
        
        if let year = components.year, year > 0 {
            return "year"
        } else if let month = components.month, month > 0 {
            return "month"
        } else if let day = components.day, day >  6 {
            return "week"
        } else if let day = components.day, day > 0 {
            return "day"
        } else {
            return "none"
        }
    }
    
    var wateringIsNeeded: Bool {
        if let latestWaterLog = latestWaterLog {
            let wateringInterval = DateInterval(start: latestWaterLog.wrappedDate, end: wrapppedWaterRequirementInterval)
            let nextWateringDate = Date(timeInterval: wateringInterval.duration, since: latestWaterLog.wrappedDate)
            return nextWateringDate > Date()
        }
        else {
            return true
        }
    }
    
    var latestWaterLog: WaterLog? {
        return waterLogArray.first
    }
    
    var waterLogArray: [WaterLog] {
        let set = waterLogs as? Set<WaterLog> ?? []
        return set.sorted {
            $0.wrappedDate > $1.wrappedDate
        }
    }
}
