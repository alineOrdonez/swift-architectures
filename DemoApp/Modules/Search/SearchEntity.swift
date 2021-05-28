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
    let category: String
    let thumb: String
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case video = "strVideo"
        case category = "strCategory"
        case thumb = "strDrinkThumb"
    }
}

struct DrinkList: Codable {
    let drinks: [Drink]?
}

