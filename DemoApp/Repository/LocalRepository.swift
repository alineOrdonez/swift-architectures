//
//  LocalRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 15/06/21.
//

import Foundation
import FirebaseStorage

enum FileError: String, LocalizedError {
    case unableToReadFile = "Couldn't read file."
    case unableToWriteFile = "Couldn't write file."
    case noObject = "Unable to find object."
    
    var errorDescription: String? {
        return self.rawValue
    }
}

class LocalRepository: Repository {
    
    var storage: StorageReference = Storage.storage().reference()
    
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
    
    func get(id: String, completion: @escaping (RepResult<FavoritesEntity, Error>) -> Void) {
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
            
            completion(.success(drink.model))
            
        } catch {
            completion(.failure(FileError.unableToReadFile))
        }
    }
    
    func list(completion: @escaping (RepResult<[FavoritesEntity], Error>) -> Void) {
        guard fileExist else {
            return completion(.success([FavoritesEntity]()))
        }
        
        do {
            let data = try Data(contentsOf: fullPath)
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            let result = drinks.map{$0.model}
            completion(.success(result))
        } catch(let error) {
            print(error)
            completion(.failure(FileError.unableToReadFile))
        }
    }
    
    func add(_ item: FavoritesEntity, completion: @escaping(RepResult<Bool, Error>) -> Void) {
        uploadImage(item) { result in
            switch result {
            case .success(let drink):
                if self.fileExist {
                    self.update(drink, completion: completion)
                } else {
                    self.insert(drink, completion: completion)
                }
                completion(.success(true))
            case .failure(_):
                if self.fileExist {
                    self.update(item, completion: completion)
                } else {
                    self.insert(item, completion: completion)
                }
                completion(.success(true))
            }
            
        }
        
    }
    
    func delete(_ item: FavoritesEntity, completion: @escaping (RepResult<Bool, Error>) -> Void) {
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
    
    private func update(_ item: FavoritesEntity, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        do {
            var data = try Data(contentsOf: fullPath)
            
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            drinks.append(UDDrink.init(drink: item))
            
            let encoder = JSONEncoder()
            data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            completion(.success(true))
            
        } catch {
            completion(.failure(FileError.unableToWriteFile))
        }
    }
    
    private func insert(_ item: FavoritesEntity, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        do {
            let drinks: [UDDrink] = [UDDrink.init(drink: item)]
            let encoder = JSONEncoder()
            let data = try encoder.encode(drinks)
            try data.write(to: fullPath, options: [.atomicWrite])
            
            completion(.success(true))
            
        } catch {
            completion(.failure(FileError.unableToWriteFile))
        }
    }
    
    func uploadImage(_ item: FavoritesEntity, completion: @escaping(RepResult<FavoritesEntity, Error>) -> Void) {
        let path = getDocumentsDirectory().appendingPathComponent("images")
        
        if !FileManager.default.fileExists(atPath: path.path) {
            do {
                try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                completion(.failure(FileError.unableToWriteFile))
            }
        }
        
        let fileName = "\(item.id).jpg"
        let fileURL = path.appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            do {
                guard let data = try? Data(contentsOf: URL(string: item.thumb)!) else {
                    return completion(.failure(FileError.noObject))
                }
                
                try data.write(to: fileURL)
                
                var newDrink = item
                newDrink.thumb = fileURL.absoluteString
                completion(.success(newDrink))
            } catch(let error) {
                print(error)
                completion(.failure(FileError.unableToWriteFile))
            }
        }
    }
    
    func deleteImage(_ name: String, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        let fileName = "\(name).jpg"
        let path = getDocumentsDirectory().appendingPathComponent("images").appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(atPath: path.absoluteString)
        } catch {
            completion(.failure(FileError.unableToWriteFile))
        }
    }
    
    func getImage(from url: URL) -> Data? {
        let path = getDocumentsDirectory().appendingPathComponent("images").appendingPathComponent(url.lastPathComponent)
        return try! Data(contentsOf: path)
    }
}
