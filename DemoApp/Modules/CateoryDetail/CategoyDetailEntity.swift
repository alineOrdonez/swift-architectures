//
//  CategoyDetailEntity.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 27/05/21.
//

import Foundation

struct CategoryDetailEntity {
    let id: String
    let name: String
    let thumb: String
    var image: Data?
    let category: String?
    
    init(id: String, name: String, thumb: String, category: String?) {
        self.id = id
        self.name = name
        self.thumb = thumb
        self.image = nil
        self.category = category
    }
}
