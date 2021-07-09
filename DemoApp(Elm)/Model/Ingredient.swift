//
//  Ingredient.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 09/07/21.
//

import Foundation

struct Ingredient: Codable {
    let name: String
    let measure: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strIngredient"
        case measure = "strMeasure"
    }
}
