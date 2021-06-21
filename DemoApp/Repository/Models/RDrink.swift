//
//  RDrink.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation
import RealmSwift

class RDrink: Object, Storable {
    typealias Entity = Drink
    
    @objc dynamic var id: String
    @objc dynamic var name: String
    @objc dynamic var category: String?
    @objc dynamic var thumb: String
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required init(drink: Drink) {
        self.id = drink.id
        self.name = drink.name
        self.category = drink.category
        self.thumb = drink.thumb
    }
    
    init(id: String, name: String, category: String? = nil, thumb: String) {
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
    }
    
    var model: Entity {
        return Entity(id: self.id, name: self.name, category: self.category, thumb: self.thumb)
    }
}
