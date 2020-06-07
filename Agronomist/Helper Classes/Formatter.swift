//
//  Formatter.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

final class Formatter {
    private static var numericRelativeDateTimeFormatter: RelativeDateTimeFormatter = {
       let rdtf = RelativeDateTimeFormatter()
        
        rdtf.dateTimeStyle = .named
        
        return rdtf
    }()
    
    private static var namedRelativeDateTimeFormatter: RelativeDateTimeFormatter = {
       let rdtf = RelativeDateTimeFormatter()
        
        rdtf.dateTimeStyle = .named
        
        return rdtf
    }()
    
    static func nextWateringText(for plant: Plant) -> String {
        if let lastWatering = plant.latestWaterLog?.wrappedDate {
            let calendar = Calendar.init(identifier: .iso8601)
            let nextWatering: Date = {
                switch plant.wrappedWaterRequirementUnit {
                case .day:
                    return calendar.date(byAdding: .day, value: plant.wrapppedWaterRequirementInterval, to: lastWatering) ?? Date()
                case .week:
                    return calendar.date(byAdding: .day, value: plant.wrapppedWaterRequirementInterval * 7, to: lastWatering) ?? Date()
                case .month:
                    return calendar.date(byAdding: .month, value: plant.wrapppedWaterRequirementInterval, to: lastWatering) ?? Date()
                case .year:
                    return calendar.date(byAdding: .year, value: plant.wrapppedWaterRequirementInterval, to: lastWatering) ?? Date()
                }
            }()
            
            return "Next watering \(namedRelativeDateTimeFormatter.localizedString(for: nextWatering, relativeTo: lastWatering).replacingOccurrences(of: "now", with: "today"))"
        }
        
        return "Initial watering due"
    }
    
    static func lastWateringText(for plant: Plant) -> String {
        if let lastWatering = plant.waterLogArray.first {
            return "Watered \(namedRelativeDateTimeFormatter.localizedString(for: lastWatering.wrappedDate, relativeTo: Date()))".replacingOccurrences(of: "now", with: "today")
        } else {
            return "Initial watering due"
        }
    }
}
