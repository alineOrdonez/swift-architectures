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
    
    func exist(id: String, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func get(id: String, completion: @escaping(RepResult<Drink, Error>) -> Void)
    func list(completion: @escaping(RepResult<[Drink], Error>) -> Void)
    func add(_ item: Drink, completion: @escaping(RepResult<Bool, Error>) -> Void)
    func delete(_ item: Drink, completion: @escaping(RepResult<Bool, Error>) -> Void)
}

protocol DomainModel {
    associatedtype Drink
    func toDomainModel() -> Drink
}
