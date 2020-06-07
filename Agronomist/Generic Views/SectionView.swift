//
//  SectionView.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct SectionView<Content>: View where Content: View {
    var label: String = ""
    let content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.headline).fontWeight(.semibold)
            Group {
                content
            }
        }
    }
}

extension SectionView {
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(label: "Hello World!") {
            Text("Good bye")
        }
    }
}
