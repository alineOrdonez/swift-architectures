//
//  RealmRepository.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 14/05/21.
//

import Foundation
import RealmSwift

class RealmRepository: Repository {
    
    typealias T = Object
    
    func get(id: String, completion: @escaping (T?, Error?) -> Void) {
        
    }
    
    func list(completion: @escaping ([T]?, Error?) -> Void) {
        
    }
    
    func add(_ item: T, completion: @escaping (Error?) -> Void) {
        
    }
    
    func delete(_ item: T, completion: @escaping (Error?) -> Void) {
        
    }
}
