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
    
    typealias T = Drink
    
    func get(id: String, completion: @escaping (T?, Error?) -> Void) {
        
        if let data = UserDefaults.standard.data(forKey: "drinks") {
            do {
                let decoder = JSONDecoder()
                let drinks = try decoder.decode([UDDrink].self, from: data)
                
                guard let drink = drinks.first(where: {$0.id == id}) else {
                    return completion(nil, UserDefaultsError.noObject)
                }
                
                completion(drink.toEntity(), nil)
            } catch(let error) {
                print("Unable to Decode (\(error))")
                completion(nil, error)
            }
        }
        completion(nil, UserDefaultsError.noValue)
    }
    
    func list(completion: @escaping ([T]?, Error?) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "drinks") {
            do {
                let decoder = JSONDecoder()
                let drinks = try decoder.decode([UDDrink].self, from: data)
                
                let result = drinks.map{$0.toEntity()}
                completion(result, nil)
            } catch(let error) {
                print("Unable to Decode (\(error))")
                completion(nil, error)
            }
        }
        completion(nil, UserDefaultsError.noValue)
    }
    
    func add(_ item: T, completion: @escaping (Error?) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "drinks") {
            do {
                let decoder = JSONDecoder()
                var drinks = try decoder.decode([UDDrink].self, from: data)
                drinks.append(item.toDTO())
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(drinks)
                UserDefaults.standard.set(data, forKey: "drinks")
            } catch(let error) {
                print("Unable to Decode (\(error))")
                completion(error)
            }
        }
        completion(UserDefaultsError.noValue)
    }
    
    func delete(_ item: T, completion: @escaping (Error?) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "drinks") {
            do {
                let decoder = JSONDecoder()
                var drinks = try decoder.decode([UDDrink].self, from: data)
                
                guard let index = drinks.firstIndex(where: {$0.id == item.id}) else {
                    return completion(UserDefaultsError.noObject)
                }
                drinks.remove(at: index)
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(drinks)
                UserDefaults.standard.set(data, forKey: "drinks")
            } catch(let error) {
                print("Unable to Decode (\(error))")
                completion(error)
            }
        }
        completion(UserDefaultsError.noValue)
    }
}
