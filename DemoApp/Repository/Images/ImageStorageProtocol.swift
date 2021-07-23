//
//  ImageStorageProtocol.swift
//  DemoApp
//
//  Created by Aline Ordoñez Garcia on 23/07/21.
//

import Foundation
import Firebase

protocol ImageStorageProtocol {
    var storage: StorageReference { get set }
    
    func uploadImage(_ item: FavoritesEntity, completion: @escaping(RepResult<FavoritesEntity, Error>) -> Void)
    func deleteImage(_ name: String, completion: @escaping(RepResult<Bool, Error>) -> Void)
}

extension ImageStorageProtocol {
    func uploadImage(_ item: FavoritesEntity, completion: @escaping(RepResult<FavoritesEntity, Error>) -> Void) {
        
        guard let data = try? Data(contentsOf: URL(string: item.thumb)!) else {
            return completion(.failure(FileError.noObject))
        }
        
        storage.child("images/\(item.name).jpg").putData(data, metadata: nil) { _, error in
            guard error == nil else {
                return completion(.failure(FileError.noObject))
            }
            
            self.storage.child("images/\(item.name).jpg").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return completion(.failure(FileError.noObject))
                }
                var updatedDrink = item
                updatedDrink.thumb = url.absoluteString
                return completion(.success(updatedDrink))
            }
        }
    }
    
    func deleteImage(_ name: String, completion: @escaping(RepResult<Bool, Error>) -> Void) {
        storage.child("images/\(name).jpg").delete { error in
            guard error == nil else {
                return completion(.failure(error!))
            }
            
            return completion(.success(true))
        }
    }
}
