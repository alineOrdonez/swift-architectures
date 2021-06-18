//
//  UserDefaultsRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation

enum UserDefaultsError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case noObject = "No object found for the given id"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        return self.rawValue
    }
}

class UserDefaultsRepository: Repository {
    
    func exist(id: String, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "drinks") else {
            return completion(.failure(UserDefaultsError.noValue))
        }
        
        do {
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let _ = drinks.first(where: {$0.id == id}) else {
                return completion(.success(false))
            }
            
            completion(.success(true))
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func get(id: String, completion: @escaping (RepResult<Drink, Error>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "drinks") else {
            return completion(.failure(UserDefaultsError.noValue))
        }
        
        do {
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let drink = drinks.first(where: {$0.id == id}) else {
                return completion(.failure(UserDefaultsError.noObject))
            }
            
            completion(.success(drink.toDomainModel()))
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func list(completion: @escaping (RepResult<[Drink], Error>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "drinks") else {
            return completion(.failure(UserDefaultsError.noValue))
        }
        
        do {
            let decoder = JSONDecoder()
            let drinks = try decoder.decode([UDDrink].self, from: data)
            
            let result = drinks.map{$0.toDomainModel()}
            completion(.success(result))
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    func add(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "drinks") else {
            return completion(.failure(UserDefaultsError.noValue))
        }
        do {
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            drinks.append(item.toDTO())
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(drinks)
            UserDefaults.standard.set(data, forKey: "drinks")
            completion(.success(true))
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func delete(_ item: Drink, completion: @escaping (RepResult<Bool, Error>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "drinks") else {
            return completion(.failure(UserDefaultsError.noValue))
        }
        
        do {
            let decoder = JSONDecoder()
            var drinks = try decoder.decode([UDDrink].self, from: data)
            
            guard let index = drinks.firstIndex(where: {$0.id == item.id}) else {
                return completion(.failure(UserDefaultsError.noObject))
            }
            drinks.remove(at: index)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(drinks)
            UserDefaults.standard.set(data, forKey: "drinks")
            completion(.success(true))
        } catch(let error) {
            print("Unable to Decode (\(error))")
            completion(.failure(error))
        }
    }
}

extension UserDefaultsRepository {
    var foundData: Bool {
        return UserDefaults.standard.data(forKey: "drinks") != nil
    }
}