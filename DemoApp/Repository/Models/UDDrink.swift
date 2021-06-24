//
//  UDDrink.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation

struct UDDrink: Codable, Storable {
    typealias Entity = Drink
    
    let id: String
    let name: String
    let category: String?
    let thumb: String
    
    init(drink: Entity) {
        self.id = drink.id
        self.name = drink.name
        self.category = drink.category
        self.thumb = drink.thumb
    }
    
    var model: Entity {
        return Entity(id: self.id, name: self.name, category: self.category, thumb: self.thumb)
    }
}
