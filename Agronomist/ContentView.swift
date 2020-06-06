//
//  ContentView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PlantWateringTodayView()
                .tabItem {
                    Image(systemName: "leaf.arrow.circlepath")
                    Text("Today")
            }
            
            PlantsListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Plants")
            }
        }.accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
