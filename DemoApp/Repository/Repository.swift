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
            return RealmRepository(.persistent)
        case .localStorage:
            return LocalRepository()
        case .inMemoryStorage:
            return RealmRepository(.inMemory)
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
    
    func exist(id: String, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func get(id: String, completion: @escaping(RepResult<FavoritesEntity, Error>) -> Void)
    func list(completion: @escaping(RepResult<[FavoritesEntity], Error>) -> Void)
    func add(_ item: FavoritesEntity, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func delete(_ item: FavoritesEntity, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func getImage(from url: URL) -> Data?
}

extension Repository {
    func getImage(from url: URL) -> Data? {
        fatalError("Method not implemented.")
    }
}

protocol Storable {
    associatedtype Entity
    
    init(drink: Entity)
    
    var model: Entity { get }
}
