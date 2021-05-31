//
//  NetworkManager.swift
//  RecipeApp
//
//  Created by Aline Arely Ordonez Garcia on 01/10/20.
//

import Foundation

public class NetworkManager: NSObject {
    
    var session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    
    public override init() {
        super.init()
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public func executeRequest<T: Decodable>(_ request: RequestProtocol, responseType: T.Type, completion: @escaping (Result<T>)-> Void) {
        
        let urlRequest = request.makeRequest()
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.domainError(description: error.localizedDescription, errorCode: 500)))
                }
            }
            
            if let data = data {
                #if DEBUG
                print("Response: ->")
                print(String(data: data, encoding: .utf8)!)
                #endif
                let result: Result<T> = self.decodeData(data: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
        }
        task.resume()
    }
    
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func decodeData<T: Decodable>(data: Data?) -> Result<T> {
        
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
