//
//  Untitled.swift
//  Trackory
//
//  Created by Robin Beckmann on 17.01.26.
//

import SwiftUI

struct NumberField: View {
    var name: String
    @Binding var value: Int?
    
    var body: some View {
        TextField(name, value: $value, format: .number)
            .keyboardType(.decimalPad)
    }
}

#Preview {
    NumberField(name: "Toast", value: .constant(100))
}
