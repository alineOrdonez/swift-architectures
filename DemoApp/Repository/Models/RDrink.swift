//
//  RDrink.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation
import RealmSwift

class RDrink: Object, DomainModel {
    @objc dynamic var id: String
    @objc dynamic var name: String
    @objc dynamic var category: String?
    @objc dynamic var thumb: String
    
    override init() {
        self.id = ""
        self.name = ""
        self.category = nil
        self.thumb = ""
    }
    
    override class func primaryKey() -> String? {
            return "id"
        }
    
    init(id: String, name: String, category: String? = nil, thumb: String) {
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
    }
    
    func toDomainModel() -> Drink {
        return Drink(id: self.id,
                     name: self.name,
                     category: self.category,
                     thumb: self.thumb)
    }
}
