//
//  Decoder.swift
//  RecipeApp
//
//  Created by Aline Arely Ordonez Garcia on 01/10/20.
//

import Foundation

class Decoder {
    static func decodeData<T: Decodable>(data: Data?) -> Result<T> {
        
        guard let validData = data else {
            return .failure(NetworkingError.invalidJSON)
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: validData)
            return .success(decoded)
        } catch(let error) {
            print(error)
            return .failure(NetworkingError.invalidJSON)
        }
    }
}
