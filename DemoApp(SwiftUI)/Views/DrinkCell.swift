//
//  DrinkCell.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 01/05/21.
//

import SwiftUI

struct DrinkCell: View {
    let drink: Drink
    
    var body: some View {
        HStack {
            Image("default_drink")
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 90)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 5) {
                Text(drink.name)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(drink.category ?? "")
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            .padding(.leading)
        }
    }
}

struct DrinkCell_Previews: PreviewProvider {
    static var previews: some View {
        DrinkCell(drink: MockData.sampleDrink)
    }
}
