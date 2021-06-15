//
//  UDDrink.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation

struct UDDrink: Codable {
    let id: String
    let name: String
    let category: String?
    let thumb: String
}

extension UDDrink {
    func toEntity() -> Drink {
        let drink = Drink(id: self.id, name: self.name, category: self.category, thumb: self.thumb)
        return drink
    }
}
