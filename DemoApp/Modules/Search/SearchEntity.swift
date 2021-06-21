//
//  Entity.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

struct Drink: Codable {
    let id: String
    let name: String
    let video: String?
    let category: String?
    let thumb: String
    var image: UIImage?
    let glass: String?
    var listOfIngredients: [[String: String]]?
    var instructions: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case video = "strVideo"
        case category = "strCategory"
        case thumb = "strDrinkThumb"
        case glass = "strGlass"
        case instructions = "strInstructions"
        case strIngredient1 = "strIngredient1"
        case strIngredient2 = "strIngredient2"
        case strIngredient3 = "strIngredient3"
        case strIngredient4 = "strIngredient4"
        case strIngredient5 = "strIngredient5"
        case strIngredient6 = "strIngredient6"
        case strIngredient7 = "strIngredient7"
        case strMeasure1 = "strMeasure1"
        case strMeasure2 = "strMeasure2"
        case strMeasure3 = "strMeasure3"
        case strMeasure4 = "strMeasure4"
        case strMeasure5 = "strMeasure5"
        case strMeasure6 = "strMeasure6"
        case strMeasure7 = "strMeasure7"
    }
    
    init(id: String, name: String, category: String? = nil, thumb: String) {
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
        self.video = nil
        self.glass = nil
        self.instructions = nil
        self.strIngredient1 = nil
        self.strIngredient2 = nil
        self.strIngredient3 = nil
        self.strIngredient4 = nil
        self.strIngredient5 = nil
        self.strIngredient6 = nil
        self.strIngredient7 = nil
        self.strMeasure1 = nil
        self.strMeasure2 = nil
        self.strMeasure3 = nil
        self.strMeasure4 = nil
        self.strMeasure5 = nil
        self.strMeasure6 = nil
        self.strMeasure7 = nil
    }
}

struct DrinkList: Codable {
    let drinks: [Drink]?
}

