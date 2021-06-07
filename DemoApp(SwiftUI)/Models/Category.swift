//
//  Category.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 01/05/21.
//

import Foundation

struct Category: Identifiable, Codable {
    let id = UUID()
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
