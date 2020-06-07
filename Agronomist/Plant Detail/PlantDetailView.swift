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
            VStack {
                Text(plant.wrappedName).font(.title).fontWeight(.semibold).padding()
                Text(nextWateringText)
                HStack {
                    Spacer()
                }
            }
            
            Section(header: Text("Growing Conditions")) {
                VStack(alignment: .leading) {
                    Text("Sun Tolerance").font(.caption).padding(.bottom)
                    Text(SunTolarance.formattedTitle(for: plant.wrappedSunTolerance)).font(.headline)
                    Text(SunTolarance.description(for: plant.wrappedSunTolerance)).font(.subheadline)
                }
                
                VStack(alignment: .leading) {
                    Text("Water Requirements").font(.caption).padding(.bottom)
                    HStack {
                        Text("\(waterRequirementText)")
                    }
                }
            }
            
            Section(header: Text("Water Logs")) {
                if plant.waterLogArray.count > 0 {
                    ForEach(plant.waterLogArray, id: \.wrappedDate) { log in
                        Text(self.dateFormatter.string(from: log.wrappedDate))
                            .onLongPressGesture {
                                self.plant.removeFromWaterLogs(log)
                        }
                    }
                } else {
                    Text("No water logs recorded yet")
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
            PlantForm(plant: self.plant, onDelete: { self.deletePlant() }) { name, sun, water_int, water_unit in
                self.plant.name = name
                self.plant.sun_tolerance = sun
                self.plant.water_req_interval = Int64(water_int)
                self.plant.water_req_unit = water_unit
                
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
    
    // MARK: Helper Functions
    
    private let relativeDateFormatter: RelativeDateTimeFormatter = {
        let rdtf = RelativeDateTimeFormatter()
        
        rdtf.dateTimeStyle = .named
        
        return rdtf
    }()
    
    var nextWateringText: String {
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
            
            return "Next watering \(relativeDateFormatter.localizedString(for: nextWatering, relativeTo: lastWatering).replacingOccurrences(of: "now", with: "today"))"
        }
        
        return "Initial watering today"
    }
    
    var waterRequirementText: String {
        return "Every \(plant.wrapppedWaterRequirementInterval) \(plant.wrappedWaterRequirementUnit)".appending(plant.wrapppedWaterRequirementInterval != 1 ? "s" : "")
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
