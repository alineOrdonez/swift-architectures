//
//  Entity.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

struct SearchEntity {
    let id: String
    let name: String
    let category: String
    let thumb: String
    var image: Data?
    
    init(id: String, name: String, category: String, thumb: String) {
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
        self.image = nil
    }
}

