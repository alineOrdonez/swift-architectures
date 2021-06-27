//
//  Category.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 27/05/21.
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
