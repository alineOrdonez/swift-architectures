//
//  Drink.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 09/07/21.
//

import Foundation
import UIKit

struct Drink: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let thumb: String
    var image: UIImage?
    let instructions: String
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case thumb = "strDrinkThumb"
        case instructions = "strInstructions"
        case ingredients = "strIngredients"
    }
}

struct DrinkList: Codable {
    let drinks: [Drink]?
}
