//
//  Icon.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import SwiftUI

protocol Icon {
    var fontScale: CGFloat { get set }
}

extension Icon {
    func font(for size: CGSize) -> Font {
        let minSide = min(size.width, size.height)
        return Font.system(size: minSide * fontScale)
    }
}
