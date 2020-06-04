//
//  Binding+DefaultValue.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/2/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import SwiftUI

extension Binding {
    init(_ source: Binding<Value?>, replacingWith nilValue: Value) {
        self.init(
            get: { source.wrappedValue ?? nilValue },
            set: { newValue in
                source.wrappedValue = newValue
        })
    }
}
