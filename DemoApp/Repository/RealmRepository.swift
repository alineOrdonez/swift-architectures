//
//  RealmRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import RealmSwift

class RealmRepository: Repository {
    
    private let realm: Realm
    
    init() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "Drinks"
        realm = try! Realm()
    }
    
    func get(id: String, completion: @escaping (Drink?, Error?) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        
        guard let item = realm.objects(RDrink.self).filter(predicate).first else {
            return completion(nil, UserDefaultsError.noObject)
        }
        completion(item.toDomainModel(), nil)
    }
    
    func list(completion: @escaping ([Drink]?, Error?) -> Void) {
        completion(getAll(), nil)
    }
    
    func add(_ item: Drink, completion: @escaping (Error?) -> Void) {
        do {
            try realm.write {
                realm.add(item.toDTO())
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    func delete(_ item: Drink, completion: @escaping (Error?) -> Void) {
        do {
            try realm.write {
                let predicate = NSPredicate(format: "id == %@", item.id)
                if let productToDelete = realm.objects(RDrink.self)
                    .filter(predicate).first {
                    realm.delete(productToDelete)
                }
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    private func getAll() -> [Drink] {
        let objects = realm.objects(RDrink.self)
        return objects.compactMap{$0.toDomainModel()}
    }
}
