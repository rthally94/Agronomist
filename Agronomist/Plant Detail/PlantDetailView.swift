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
    @State private var editMode: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var indexSetToDelete: IndexSet?
    
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
                    }
                    .onDelete(perform: delete)
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("This action cannot be undone."),
                        primaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                if let index = self.indexSetToDelete?.first {
                                    let log = self.plant.waterLogArray[index]
                                    CoreDataHelper.deleteWaterLog(log, from: self.plant, in: self.moc)
                                }
                        }),
                        secondaryButton: .cancel())
                })
                } else {
                    Text("No water logs recorded yet")
                }
            }
        }
    }
    
    func delete(at offset: IndexSet) {
        self.indexSetToDelete = offset
        self.showDeleteAlert = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            detailContent
            Button(
                action: {
                    CoreDataHelper.addWaterLog(date: Date(), to: self.plant, in: self.moc)
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
            PlantForm(plant: self.plant, onDelete: { self.deletePlant() }, onSave: { name, sun, water_int, water_unit in
                CoreDataHelper.updatePlant(self.plant, name: name, sunTolerance: sun, waterRequirementInterval: water_int, waterRequirementUnit: water_unit, to: self.moc)
            })
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("\(plant.name ?? "NO_NAME")", displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {self.editMode = true} )
    }
    
    func formatForDisplay(_ input: String) -> String {
        return input.replacingOccurrences(of: "|", with: " ").replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    // MARK: Helper Functions
    
    var nextWateringText: String {
        Formatter.nextWateringText(for: plant)
    }
    
    var waterRequirementText: String {
        return "Every \(plant.wrapppedWaterRequirementInterval) \(plant.wrappedWaterRequirementUnit)".appending(plant.wrapppedWaterRequirementInterval != 1 ? "s" : "")
    }
    
    // MARK: Intents
    
    private func deletePlant() {
        CoreDataHelper.deletePlant(plant, from: moc)
        presentationMode.wrappedValue.dismiss()
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
