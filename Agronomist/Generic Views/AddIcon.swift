//
//  AddIcon.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct AddIcon: View, Icon {
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "plus.circle.fill").font( self.font(for: geometry.size))
        }
    }
    
    var fontScale: CGFloat = 0.9
}

struct AddIcon_Previews: PreviewProvider {
    static var previews: some View {
        AddIcon()
    }
}
