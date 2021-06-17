//
//  Repository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation

protocol Repository: AnyObject {
    
    func get(id: String, completion: @escaping(Drink?, Error?) -> Void)
    func list(completion: @escaping([Drink]?, Error?) -> Void)
    func add(_ item: Drink, completion: @escaping(Error?) -> Void)
    func delete(_ item: Drink, completion: @escaping(Error?) -> Void)
}

protocol DomainModel {
    associatedtype Drink
    func toDomainModel() -> Drink
}
