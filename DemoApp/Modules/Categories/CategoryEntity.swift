//
//  CategoryEntity.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

struct Category: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}

struct CategoryList: Codable {
    let categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case categories = "drinks"
    }
}
