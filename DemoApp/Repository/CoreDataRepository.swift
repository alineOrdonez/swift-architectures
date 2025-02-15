//
//  CoreDataRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import CoreData
import FirebaseStorage


class CoreDataRepository: Repository {
    
    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func exist(id: String, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        do {
            let total = try getManagedObjects(with: predicate).count
            completion(.success(total > 0))
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    func get(id: String, completion: @escaping (RepResult<FavoritesEntity, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        do {
            let items = try getManagedObjects(with: predicate)
            guard let result = items.map({$0.model}).first else {
                return completion(.failure(UserDefaultsError.unableToDecode))
            }
            completion(.success(result))
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    func list(completion: @escaping (RepResult<[FavoritesEntity], Error>) -> Void) {
        do {
            let objects = try getManagedObjects(with: nil)
            let result = objects.map{$0.model}
            return completion(.success(result))
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    func add(_ item: FavoritesEntity, completion: @escaping(RepResult<Bool, Error>) -> Void) {
        let drink = DrinkMO(context: persistentContainer.viewContext)
        drink.id = item.id
        drink.name = item.name
        drink.category = item.category
        drink.thumb = item.thumb
        persistentContainer.viewContext.insert(drink)
        saveContext(completion: completion)
    }
    
    func delete(_ item: FavoritesEntity, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", item.id)
        do {
            let items = try getManagedObjects(with: predicate)
            persistentContainer.viewContext.delete(items.first!)
            saveContext(completion: completion)
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    private func getManagedObjects(with predicate: NSPredicate?) throws -> [DrinkMO] {
        let entityName = String(describing: DrinkMO.self)
        let request = NSFetchRequest<DrinkMO>(entityName: entityName)
        request.predicate = predicate
        
        return try persistentContainer.viewContext.fetch(request)
    }
    
    // MARK: - Core Data Saving support
    private func saveContext(completion: @escaping (RepResult<Bool, Error>) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(true))
            } catch(let error) {
                context.rollback()
                completion(.failure(error))
            }
        }
    }
}
