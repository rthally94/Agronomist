//
//  WaterLog+CoreDataClass.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/4/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//
//

import Foundation
import CoreData

@objc(WaterLog)
public class WaterLog: NSManagedObject {
    var wrappedDate: Date {
        return date ?? Date()
    }
}
