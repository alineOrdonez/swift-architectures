//
//  NetworkAPI.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 02/06/21.
//

import Foundation
import Combine

enum APIError: Error {
    case requestFailed
    case invalidResponse
    case invalidJSON
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidResponse: return "Response Unsuccessful"
        case .invalidJSON: return "JSON Parsing Failure"
        }
    }
}

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var query: String { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = query
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

protocol NetworkAPIProtocol {
    var session: URLSession { get }
    func execute<T>(request: URLRequest, responseType: T.Type, retries: Int) -> AnyPublisher<T, Error> where T: Decodable
}

extension NetworkAPIProtocol {
    
    func execute<T>(request: URLRequest, responseType: T.Type, retries: Int) -> AnyPublisher<T, Error> where T: Decodable {
        return session.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}

enum DrinkEndpoint {
    case categoryList
    case drinksIn(String)
    case search(String)
    case drink(String)
}

extension DrinkEndpoint: Endpoint {
    
    var base: String {
        return "https://www.thecocktaildb.com"
    }
    
    var query: String {
        switch self {
        case .categoryList:
            return "c=list"
        case .drinksIn(let category):
            return "c=\(category)"
        case .search(let value):
            return "s=\(value)"
        case .drink(let id):
            return "i=\(id)"
        }
    }
    
    var path: String {
        switch self {
        case .categoryList:
            return "/api/json/v1/1/list.php"
        case .drinksIn(_):
            return "/api/json/v1/1/filter.php"
        case .search(_):
            return "/api/json/v1/1/search.php"
        case .drink(_):
            return "/api/json/v1/1/lookup.php"
        }
    }
}
