//
//  WaterIcon.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct WaterIcon: View, Icon {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .foregroundColor(.blue)
                Text("💧").font(self.font(for: geometry.size))
            }.rotationEffect(.degrees(-30))
        }
    }
    
    var fontScale: CGFloat = 0.6
}

struct WaterIcon_Previews: PreviewProvider {
    static var previews: some View {
        WaterIcon()
    }
}
