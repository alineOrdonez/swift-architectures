//
//  LocalRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 15/06/21.
//

import Foundation

enum FileError: String, LocalizedError {
    case unableToReadFile = "Couldn't read file."
    case unableToWriteFile = "Couldn't write file."
    case noObject = "Unable to find object."
    
    var errorDescription: String? {
        return self.rawValue
    }
}

class LocalRepository: Repository {
    
    func exist(id: String, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        guard fileExist else {
            return completion(.success(false))
        }
        
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let _ = drinks.first(where: {$0.id == id}) else {
                return completion(.success(false))
            }
            
            return completion(.success(true))
        } catch(let error) {
            return completion(.failure(error))
        }
    }
    
    func get(id: String, completion: @escaping (RepResult<Drink, Error>) -> Void) {
        guard fileExist else {
            return completion(.failure(FileError.unableToReadFile))
        }
        
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let drink = drinks.first(where: {$0.id == id}) else {
                return completion(.failure(FileError.noObject))
            }
            
            completion(.success(drink.toDomainModel()))
            
        } catch {
            completion(.failure(FileError.unableToReadFile))
        }
    }
    
    func list(completion: @escaping (RepResult<[Drink], Error>) -> Void) {
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            let result = drinks.map{$0.toDomainModel()}
            completion(.success(result))
        } catch {
            completion(.failure(FileError.unableToReadFile))
        }
    }
    
    func add(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        if fileExist {
            update(item, completion: completion)
        } else {
            insert(item, completion: completion)
        }
    }
    
    func delete(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        do {
            var data = try Data(contentsOf: fullPath)
            
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let index = drinks.firstIndex(where: {$0.id == item.id}) else {
                return completion(.failure(FileError.noObject))
            }
            drinks.remove(at: index)
            
            let encoder = JSONEncoder()
            data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            completion(.success(true))
            
        } catch {
            completion(.failure(FileError.unableToReadFile))
        }
    }
}

extension LocalRepository {
    var fullPath: URL {
        return getDocumentsDirectory().appendingPathComponent("Drinks").appendingPathExtension("json")
    }
    
    var fileExist: Bool {
        return FileManager.default.fileExists(atPath: fullPath.path)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    private func update(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        do {
            var data = try Data(contentsOf: fullPath)
            
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            drinks.append(item.toDTO())
            
            let encoder = JSONEncoder()
            data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            completion(.success(true))
            
        } catch {
            completion(.failure(FileError.unableToWriteFile))
        }
    }
    
    private func insert(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        do {
            let drinks: [UDDrink] = [item.toDTO()]
            let encoder = JSONEncoder()
            let data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            completion(.success(true))
            
        } catch {
            completion(.failure(FileError.unableToWriteFile))
        }
    }
}
