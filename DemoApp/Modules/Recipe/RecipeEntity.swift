//
//  RecipeEntity.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 27/05/21.
//

import Foundation

struct RecipeEntity {
    let id: String
    let name: String
    let video: String?
    var thumb: String
    var image: Data?
    let category: String
    let glass: String
    let instructions: String
    var ingredients: [[String: String]] = [[String: String]]()
    
    init(drink: Drink) {
        self.id = drink.id
        self.name = drink.name
        self.video = drink.video
        self.thumb = drink.thumb
        self.category = drink.category ?? ""
        self.glass = drink.glass ?? ""
        self.instructions = drink.instructions ?? ""
        
        self.addIngredientes(drink)
    }

    private mutating func addIngredientes(_ drink: Drink) {
        let ingredients: [String] = [drink.strIngredient1, drink.strIngredient2, drink.strIngredient3, drink.strIngredient4, drink.strIngredient5, drink.strIngredient6, drink.strIngredient7].compactMap({$0}).filter({ !$0.isEmpty })
        
        let measures: [String] = [drink.strMeasure1, drink.strMeasure2, drink.strMeasure3, drink.strMeasure4, drink.strMeasure5, drink.strMeasure6, drink.strMeasure7].compactMap { measure in
            guard let measure = measure, !measure.isEmpty else {
                return "-"
            }
            return measure
        }
        var array = [[String: String]]()
        
        for (index, element) in ingredients.enumerated() {
            let dictionary = [element: measures[index]]
            array.append(dictionary)
        }
        
        self.ingredients = array
    }
}
