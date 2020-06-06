//
//  PlantDetailView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var plant: Plant
    @State var editMode: Bool = false
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    var lastLoggedString: String {
        if let lastUpdate = plant.waterLogArray.first {
            return dateFormatter.string(from: lastUpdate.wrappedDate)
        } else {
            return "Not logged."
        }
    }
    
    var detailContent: some View {
        List {
            Section {
                plant.name.map(Text.init)
                VStack(alignment: .leading) {
                    Text("Last Watered").font(.caption)
                    Text(lastLoggedString)
                }
                
            }
            
            Section(header: Text("Growing Conditions")) {
                VStack(alignment: .leading) {
                    Text("Sun Tolerance").font(.caption)
                    plant.sun_tolerance.map(formatForDisplay).map(Text.init)
                }
                
                VStack(alignment: .leading) {
                    Text("Water Requirements").font(.caption)
                    HStack {
// TODO : Add Formatter                        Text("\(plant.water_req_interval)")
                        Text("fda")
                    }
                }
            }
            
            Section(header: Text("Water Logs")) {
                ForEach(plant.waterLogArray, id: \.wrappedDate) { log in
                    Text(self.dateFormatter.string(from: log.wrappedDate))
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            detailContent
            Button(
                action: {
                    let log = WaterLog(context: self.moc)
                    log.date = Date()
                    self.plant.addToWaterLogs(log)
                    
                    self.saveContext()
            },
                label: {
                    Text("Log Water")
                        .fontWeight(.bold)
            })
                .buttonStyle(RoundedButtonStyle())
        }
        .sheet(
            isPresented: $editMode,
            onDismiss: {
                self.editMode = false
        }) {
            PlantForm(plant: self.plant, onDelete: { self.deletePlant() }) { name, sun, water_int in
                self.plant.name = name
                self.plant.sun_tolerance = sun
                self.plant.water_req_interval = water_int
                
                self.saveContext()
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("\(plant.name ?? "NO_NAME")", displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {self.editMode = true} )
    }
    
    func formatForDisplay(_ input: String) -> String {
        return input.replacingOccurrences(of: "|", with: " ").replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    // MARK: Intents
    
    private func deletePlant() {
        print("Delete Pressed")
        moc.delete(plant)
        self.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Cannot save context: \(error)")
            }
        }
    }
}

struct RoundedButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let plant = Plant(context: moc)
        plant.id = UUID()
        plant.name = "Test Plant"
        
        return PlantDetailView(plant: plant)
    }
}
