//
//  CoreDataRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import CoreData


class CoreDataRepository<CDObject: NSManagedObject>: Repository {
    
    typealias T = CDObject
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func get(id: String, completion: @escaping(T?, Error?) -> Void) {
        
    }
    
    func list(completion: @escaping([T]?, Error?) -> Void) {
        
    }
    
    func add(_ item: T, completion: @escaping(Error?) -> Void) {
        
    }
    
    func delete(_ item: T, completion: @escaping(Error?) -> Void) {
        
    }
}
