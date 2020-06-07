//
//  PlantTodayViewListRow.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantTodayViewListRow: View {
    
    @State var isMarkedOff: Bool = false
    
    var plant: Plant
    
    var lastWateredText: String {
        Formatter.lastWateringText(for: plant)
    }
    
    var onMarkPress: (Bool) -> Void = {_ in}
    
    var body: some View {
        HStack(alignment: .center) {
            WaterIcon()
                .foregroundColor(.white)
                .opacity(isMarkedOff ? 0.5 : 1.0)
                .frame(width: iconSize, height: iconSize)
            
            VStack(alignment: .leading) {
                plantNameText
                Spacer()
                plantLastWateredText
            }
            
            Spacer()
            
            Button(
                action: {
                    withAnimation {
                        self.isMarkedOff.toggle()
                        self.onMarkPress(self.isMarkedOff)
                    }
            },
                label: {
                    if isMarkedOff {
                        Image(systemName: "checkmark.square").resizable().scaledToFit().frame( height: 20) .accentColor(.green).transition(.asymmetric(insertion: .scale, removal: .identity))
                    } else {
                        Image(systemName: "square").resizable().scaledToFit().frame( height: 20) .accentColor(.gray).transition(.asymmetric(insertion: .scale, removal: .identity))
                    }
                    
            })
        }
        .padding()
        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(backgroundColor))
    }
    
    // MARK: Drawing Contstants
    let iconSize: CGFloat = 45
    
    
    // MARK: Computed Drawing Properties
    var plantNameText: Text {
        return Text(plant.wrappedName)
            .font(.headline)
            .foregroundColor(isMarkedOff ? .gray : nil)
            .strikethrough(isMarkedOff, color: .gray)
    }
    
    var plantLastWateredText: Text {
        return Text(lastWateredText)
            .font(.subheadline)
            .foregroundColor(isMarkedOff ? .gray : nil)
            .strikethrough(isMarkedOff, color: .gray)
    }
    
    var backgroundColor: Color {
        if isMarkedOff {
            return Color(UIColor.systemGray6)
        } else {
            return Color(UIColor.systemGray4)
        }
    }
}

struct PlantTodayViewListRow_Previews: PreviewProvider {
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: moc)
        
        plant.id = UUID()
        plant.name = "My Plant"
        
        let waterLog = WaterLog(context: moc)
        waterLog.date = Date(timeIntervalSinceNow: -345600)
        
        plant.addToWaterLogs(waterLog)
        
        
        return PlantTodayViewListRow(plant: plant)
    }
}
