//
//  ItemDetailRow.swift
//  Trackory
//
//  Created by Robin Beckmann on 18.01.26.
//

import SwiftUI

struct ItemDetailRow: View {
    var title: String
    var content: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(content)
        }
        .padding(8)
    }
}

#Preview {
    ItemDetailRow(title: "Calories", content: "100")
}
