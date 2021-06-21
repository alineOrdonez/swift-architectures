//
//  DrinkMO+CoreDataProperties.swift
//  DemoApp
//
//  Created by Aline Ordoñez Garcia on 20/06/21.
//
//

import Foundation
import CoreData


extension DrinkMO: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkMO> {
        return NSFetchRequest<DrinkMO>(entityName: "DrinkMO")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var thumb: String

}
