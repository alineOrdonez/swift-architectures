//
//  HTTPMethod.swift
//  RecipeApp
//
//  Created by Aline Arely Ordonez Garcia on 01/10/20.
//

import Foundation

@frozen
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

