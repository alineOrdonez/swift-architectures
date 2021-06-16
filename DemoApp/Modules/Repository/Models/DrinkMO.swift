//
//  DrinkMO.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/06/21.
//

import Foundation
import CoreData

extension DrinkMO: DomainModel {
    
    func toDomainModel() -> Drink {
        return Drink(id: self.id!,
                     name: self.name!,
                     category: self.category,
                     thumb: self.thumb!)
    }
}
