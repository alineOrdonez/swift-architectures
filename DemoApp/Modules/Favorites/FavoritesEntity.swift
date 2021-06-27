//
//  FavoritesEntity.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 27/05/21.
//

import Foundation

struct FavoritesEntity {
    let id: String
    let name: String
    var thumb: String
    var image: Data?
    let category: String?
    
    init(id: String, name: String, thumb: String, category: String?) {
        self.id = id
        self.name = name
        self.thumb = thumb
        self.category = category
        self.image = nil
    }
}
