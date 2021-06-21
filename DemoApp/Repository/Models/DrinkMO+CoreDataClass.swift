//
//  DrinkMO+CoreDataClass.swift
//  DemoApp
//
//  Created by Aline Ordoñez Garcia on 20/06/21.
//
//

import Foundation
import CoreData


public class DrinkMO: NSManagedObject, Storable {
    
    typealias Entity = Drink
    
    required convenience init(drink: Entity) {
        self.init()
        id = drink.id
        name = drink.name
        category = drink.category
        thumb = drink.thumb
    }
    
    var model: Entity {
        return Entity(id: self.id, name: self.name, category: self.category, thumb: self.thumb)
    }
}

