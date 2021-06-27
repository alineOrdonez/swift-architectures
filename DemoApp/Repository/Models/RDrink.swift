//
//  RDrink.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation
import RealmSwift
import UIKit

class RDrink: Object, Storable {
    typealias Entity = FavoritesEntity
    
    @objc dynamic var id: String
    @objc dynamic var name: String
    @objc dynamic var category: String?
    @objc dynamic var thumb: String
    @objc dynamic var image: Data?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        self.id = ""
        self.name = ""
        self.category = nil
        self.thumb = ""
        self.image = nil
    }
    
    required init(drink: Entity) {
        self.id = drink.id
        self.name = drink.name
        self.category = drink.category
        self.thumb = drink.thumb
        self.image = try! Data(contentsOf: URL(string: drink.thumb)!)
    }
    
    init(id: String, name: String, category: String? = nil, thumb: String, image: Data) {
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
        self.image = image
    }
    
    var model: Entity {
        return Entity(id: self.id, name: self.name, thumb: self.thumb, category: self.category)
    }
}
