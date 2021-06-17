//
//  CoreDataRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import CoreData


class CoreDataRepository: Repository {
    
    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func get(id: String, completion: @escaping(Drink?, Error?) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        do {
            let items = try getManagedObjects(with: predicate)
            let result = items.map{$0.toDomainModel()}.first
            completion(result, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func list(completion: @escaping([Drink]?, Error?) -> Void) {
        do {
            let objects = try getManagedObjects(with: nil)
            let result = objects.map{$0.toDomainModel()}
            return completion(result, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func add(_ item: Drink, completion: @escaping(Error?) -> Void) {
        var drink = DrinkMO()
        drink.id = item.id
        drink.name = item.name
        drink.category = item.category
        drink.thumb = item.thumb
        persistentContainer.viewContext.insert(drink)
        saveContext(completion: completion)
    }
    
    func delete(_ item: Drink, completion: @escaping(Error?) -> Void) {
        let predicate = NSPredicate(format: "id == %@", item.id)
        do {
            let items = try getManagedObjects(with: predicate)
            persistentContainer.viewContext.delete(items.first!)
            saveContext(completion: completion)
        } catch {
            completion(error)
        }
    }
    
    private func getManagedObjects(with predicate: NSPredicate?) throws -> [DrinkMO] {
        let entityName = String(describing: DrinkMO.self)
        let request = NSFetchRequest<DrinkMO>(entityName: entityName)
        request.predicate = predicate
        
        return try persistentContainer.viewContext.fetch(request)
    }
    
    // MARK: - Core Data Saving support
    private func saveContext(completion: @escaping(Error?) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }
}
