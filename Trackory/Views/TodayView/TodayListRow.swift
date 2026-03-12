//
//  TodayListRow.swift
//  Trackory
//
//  Created by Robin Beckmann on 12.03.26.
//

import SwiftUI

struct TodayListRow: View {
    @Environment(\.modelContext) private var context
    var consumption: Consumption
    var onIncrease: (Consumption) -> Void
    var onDecrease: (Consumption) -> Void
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(consumption.name)
                    .lineLimit(1)
                    .padding(.trailing)
                
                Text("\(consumption.calories) calories")
                    .font(.caption)
                    .fontWeight(.light)
            }
            
            Spacer()
            
            HStack {
                Button {
                    onDecrease(consumption)
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.bordered)
                
                Text("\(consumption.quantity)")
                    .frame(width: 25)
                
                Button {
                    onIncrease(consumption)
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(8)
    }
}
