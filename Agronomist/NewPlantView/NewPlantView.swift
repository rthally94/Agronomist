//
//  NewPlantView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/2/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct NewPlantView: View {
    var body: some View {
        NavigationView {
            PlantEditorForm()
            .navigationBarTitle("New Plant", displayMode: .inline)
        }
    }
}

struct NewPlantView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlantView()
    }
}
