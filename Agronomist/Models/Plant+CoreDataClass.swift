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
    
    var wrapppedWaterRequirementInterval: Int {
        return Int(water_req_interval)
    }
    
    var wrappedWaterRequirementUnit: WaterRequirementUnit {
        return WaterRequirementUnit(rawValue: water_req_unit ?? "") ?? .day
    }
    
    var wateringIsNeeded: Bool {
        if let latestWaterLog = latestWaterLog {
            let wateringInterval: DateComponents = {
                switch wrappedWaterRequirementUnit {
                case .day: return DateComponents(day: wrapppedWaterRequirementInterval)
                case .week: return DateComponents(day: wrapppedWaterRequirementInterval * 7)
                case .month: return DateComponents(month: wrapppedWaterRequirementInterval)
                case .year: return DateComponents(year: wrapppedWaterRequirementInterval)
                }
            }()
            
            let nextWateringDate = latestWaterLog.wrappedDate + DateInterval(start: latestWaterLog.wrappedDate, end: wateringInterval.date ?? Date()).duration
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
