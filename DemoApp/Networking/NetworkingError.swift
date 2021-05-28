//
//  NetworkingError.swift
//  RecipeApp
//
//  Created by Aline Arely Ordonez Garcia on 01/10/20.
//

import Foundation

public enum NetworkingError: Error {
    case domainError(description: String, errorCode: Int)
    case invalidResponse
    case invalidJSON
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .domainError(let descr, _):
            return NSLocalizedString(descr, comment: "Invalid domain")
        case .invalidResponse:
            return NSLocalizedString("Could not process response", comment: "Invalid Response")
        case .invalidJSON:
            return NSLocalizedString("Error al procesar la información", comment: "Invalid JSON")
        }
    }
    
    public var errorCode: Int? {
        switch self {
        case .invalidJSON: return nil
        case .invalidResponse: return 404
        case .domainError(_, let errorCode): return errorCode
        }
    }
}
