//
//  SunTolarance.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

enum SunTolarance: String, CaseIterable {
    case fullShade = "full_shade"
    case partialShade = "partial_shade"
    case lightShade = "light_shade"
    case fullSun = "full_sun"
    
    static func formattedTitle(for state: SunTolarance) -> String {
        return state.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    static func description(for state: SunTolarance) -> String {
        switch state {
        case .fullShade: return "1 hour of direct sun"
        case .partialShade: return "2 hours of direct sun"
        case .lightShade: return "3-5 hours of direct sun"
        case .fullSun: return "6+ hours of direct sun"
        }
    }
}
