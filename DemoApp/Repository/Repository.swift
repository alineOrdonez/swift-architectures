//
//  Repository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation

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
    
    func updoadImage(_ item: Drink, completion: @escaping(RepResult<Drink, Error>) -> Void)
}

extension Repository {
    
    func updoadImage(_ item: Drink, completion: @escaping(RepResult<Drink, Error>) -> Void) {
        
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
}

protocol Storable {
    associatedtype Entity
    
    init(drink: Entity)
    
    var model: Entity { get }
}
