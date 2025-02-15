//
//  RealmRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import RealmSwift
import FirebaseStorage

enum StorageType {
    case persistent, inMemory
}

class RealmRepository: Repository {
    
    private let realm: Realm
    
    init(_ storageType: StorageType) {
        if storageType == .inMemory {
            var config = Realm.Configuration()
            config.inMemoryIdentifier = "RealmDatabase"
            
            realm = try! Realm(configuration: config)
        } else {
            realm = try! Realm()
        }
    }
    
    func exist(id: String, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        if let _ = realm.object(ofType: RDrink.self, forPrimaryKey: id) {
            completion(.success(true))
        } else {
            completion(.success(false))
        }
    }
    
    func get(id: String, completion: @escaping (RepResult<FavoritesEntity, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        
        guard let item = realm.objects(RDrink.self).filter(predicate).first else {
            return completion(.failure(UserDefaultsError.noObject))
        }
        completion(.success(item.model))
    }
    
    func list(completion: @escaping (RepResult<[FavoritesEntity], Error>) -> Void) {
        let objects = realm.objects(RDrink.self)
        let domainObjects: [FavoritesEntity] = objects.compactMap{$0.model}
        completion(.success(domainObjects))
    }
    
    func add(_ item: FavoritesEntity, completion: @escaping(RepResult<Bool, Error>) -> Void) {
        do {
            try realm.write {
                realm.add(RDrink.init(drink: item))
                completion(.success(true))
            }
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    func delete(_ item: FavoritesEntity, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        do {
            try realm.write {
                let predicate = NSPredicate(format: "id == %@", item.id)
                if let productToDelete = realm.objects(RDrink.self)
                    .filter(predicate).first {
                    realm.delete(productToDelete)
                }
                completion(.success(true))
            }
        } catch(let error) {
            completion(.failure(error))
        }
    }
}
