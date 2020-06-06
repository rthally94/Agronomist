//
//  CardView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct CardView<Content>: View where Content: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Circle()
                .opacity(0.2)
            Circle()
                .strokeBorder(lineWidth: 10, antialiased: true)
                .opacity(0.2)
            
            content()
        }
        .frame(maxWidth: 400)
        .aspectRatio(2/3, contentMode: .fit)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("Card Content")
        }
    }
}
