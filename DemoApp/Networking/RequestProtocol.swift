//
//  RequestProtocol.swift
//  RecipeApp
//
//  Created by Aline Arely Ordonez Garcia on 01/10/20.
//

import Foundation

public protocol RequestProtocol {
    var url: String { get }
    var httpMethod: HTTPMethod { get set }
    var params: [String: Any]? { get  set }
    var timeoutInterval: TimeInterval { get set }
    var headers: [String: String]? { get set }
    var cachePolicy: URLRequest.CachePolicy { get set }
    
    init(url: String, httpMethod: HTTPMethod, cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval)
    
    func makeRequest() -> URLRequest
}
