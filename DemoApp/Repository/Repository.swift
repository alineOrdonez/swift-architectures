//
//  Repository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import FirebaseStorage

enum RepoType: Int {
    case coreData
    case realm
    case localStorage
    case userDefaults
    case inMemoryStorage
    case keyChain
    
    static var current: RepoType = .userDefaults
    
    func repository() -> Repository {
        switch self {
        case .coreData:
            return CoreDataRepository(persistentContainer: CoreDataManager.shared.persistentContainer)
        case .realm:
            return RealmRepository()
        case .localStorage:
            return LocalRepository()
        case .inMemoryStorage:
            return InMemoryRepository()
        case .userDefaults:
            return UserDefaultsRepository()
        case .keyChain:
            return UserDefaultsRepository()
        }
    }
}

enum RepResult<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}

protocol Repository: AnyObject {
    var storage: StorageReference { get set }
    
    func exist(id: String, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func get(id: String, completion: @escaping(RepResult<Drink, Error>) -> Void)
    func list(completion: @escaping(RepResult<[Drink], Error>) -> Void)
    func add(_ item: Drink, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func delete(_ item: Drink, completion: @escaping(RepResult<Bool, Error>) -> Void)
    
    func uploadImage(_ item: Drink, completion: @escaping(RepResult<Drink, Error>) -> Void)
    func deleteImage(_ name: String, completion: @escaping(RepResult<Bool, Error>) -> Void)
}

extension Repository {
    
    func uploadImage(_ item: Drink, completion: @escaping(RepResult<Drink, Error>) -> Void) {
        
        guard let data = try? Data(contentsOf: URL(string: item.thumb)!) else {
            return completion(.failure(FileError.noObject))
        }
        
        storage.child("images/\(item.name).jpg").putData(data, metadata: nil) { _, error in
            guard error == nil else {
                return completion(.failure(FileError.noObject))
            }
            
            self.storage.child("images/\(item.name).jpg").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return completion(.failure(FileError.noObject))
                }
                var updatedDrink = item
                updatedDrink.thumb = url.absoluteString
                return completion(.success(updatedDrink))
            }
        }
    }
    
    func deleteImage(_ name: String, completion: @escaping(RepResult<Bool, Error>) -> Void) {
        storage.child("images/\(name).jpg").delete { error in
            guard error == nil else {
                return completion(.failure(error!))
            }
            
            return completion(.success(true))
        }
    }
}

protocol Storable {
    associatedtype Entity
    
    init(drink: Entity)
    
    var model: Entity { get }
}
