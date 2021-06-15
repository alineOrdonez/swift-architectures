//
//  CDDrink.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation
import CoreData

struct CDDrinK: Codable {
    let id: String
    let name: String
    let category: String?
    let thumb: String
    
    init(id: String, name: String, category: String? = nil, thumb: String) {
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
    }
}
