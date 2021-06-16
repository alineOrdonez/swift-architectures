//
//  LocalRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 15/06/21.
//

import Foundation

enum FileError: String, LocalizedError {
    case unableToReadFile = "Couldn't read file."
    case unableToWriteFile = "aCouldn't write file."
    case noObject = "Unable to find object."
    
    var errorDescription: String? {
        return self.rawValue
    }
}

class LocalRepository: Repository {
    
    func exist(id: String, completion: @escaping (Bool) -> Void) {
        let fullPath = getDocumentsDirectory().appendingPathComponent("Drinks").appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let _ = drinks.first(where: {$0.id == id}) else {
                return completion(false)
            }
            
            return completion(true)
            
        } catch {
            return completion(false)
        }
    }
    
    func get(id: String, completion: @escaping (Drink?, Error?) -> Void) {
        let fullPath = getDocumentsDirectory().appendingPathComponent("Drinks").appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let drink = drinks.first(where: {$0.id == id}) else {
                return completion(nil, FileError.noObject)
            }
            
            return completion(drink.toDomainModel(), nil)
            
        } catch {
            completion(nil, FileError.unableToReadFile)
        }
    }
    
    func list(completion: @escaping ([Drink]?, Error?) -> Void) {
        let fullPath = getDocumentsDirectory().appendingPathComponent("Drinks").appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            let result = drinks.map{$0.toDomainModel()}
            completion(result, nil)
        } catch {
            completion(nil, FileError.unableToReadFile)
        }
    }
    
    func add(_ item: Drink, completion: @escaping (Error?) -> Void) {
        let fullPath = getDocumentsDirectory().appendingPathComponent("Drinks").appendingPathExtension("json")
        
        do {
            var data = try Data(contentsOf: fullPath)
            
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            drinks.append(item.toDTO())
            
            let encoder = JSONEncoder()
            data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            return completion(nil)
            
        } catch {
            completion(FileError.unableToWriteFile)
        }
    }
    
    func delete(_ item: Drink, completion: @escaping (Error?) -> Void) {
        let fullPath = getDocumentsDirectory().appendingPathComponent("Drinks").appendingPathExtension("json")
        
        do {
            var data = try Data(contentsOf: fullPath)
            
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let index = drinks.firstIndex(where: {$0.id == item.id}) else {
                return completion(FileError.noObject)
            }
            drinks.remove(at: index)
            
            let encoder = JSONEncoder()
            data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            return completion(nil)
            
        } catch {
            completion(FileError.unableToWriteFile)
        }
    }
}

extension LocalRepository {
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
