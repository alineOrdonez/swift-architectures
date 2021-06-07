//
//  Drink.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 01/05/21.
//

import Foundation
import UIKit

struct Drink: Identifiable, Codable {
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
}

struct DrinkList: Codable {
    let drinks: [Drink]?
}

struct MockData {
    
    static let drinks = [sampleDrink, sampleDrink, sampleDrink]
    
    static let sampleDrink = Drink(id: "11007", name: "Margarita", video: nil, category: "Ordinary Drink", thumb: "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg", image: nil, glass: nil, listOfIngredients: nil, instructions: nil, strIngredient1: nil, strIngredient2: nil, strIngredient3: nil, strIngredient4: nil, strIngredient5: nil, strIngredient6: nil, strIngredient7: nil, strMeasure1: nil, strMeasure2: nil, strMeasure3: nil, strMeasure4: nil, strMeasure5: nil, strMeasure6: nil, strMeasure7: nil)
}


