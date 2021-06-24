//
//  InMemoryRepository.swift
//  DemoApp
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

import Foundation
import FirebaseStorage

final class InMemoryRepository: Repository {
    
    var storage: StorageReference = Storage.storage().reference()
    
    private static var drinks: [Drink] = [Drink]()
    
    func exist(id: String, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        if let _ = Self.drinks.filter({$0.id == id}).first {
            return completion(.success(true))
        }
        return completion(.success(false))
    }
    
    func get(id: String, completion: @escaping (RepResult<Drink, Error>) -> Void) {
        if let drink = Self.drinks.filter({$0.id == id}).first {
            return completion(.success(drink))
        }
        return completion(.failure(FileError.noObject))
    }
    
    func list(completion: @escaping (RepResult<[Drink], Error>) -> Void) {
        completion(.success(Self.drinks))
    }
    
    func add(_ item: Drink, completion: @escaping(RepResult<Bool, Error>) -> Void) {
        updoadImage(item) { result in
            switch result {
            case .success(let drink):
                Self.drinks.append(drink)
            case .failure(_):
                Self.drinks.append(item)
            }
        }
        completion(.success(true))
    }
    
    func delete(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        guard let index = Self.drinks.firstIndex(where: {$0.id == item.id}) else {
            return completion(.failure(FileError.noObject))
        }
        
        Self.drinks.remove(at: index)
        completion(.success(true))
    }
    
    
}
