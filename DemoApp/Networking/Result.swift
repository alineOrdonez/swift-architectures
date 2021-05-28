//
//  Enums.swift
//  RecipeApp
//
//  Created by Aline Arely Ordonez Garcia on 01/10/20.
//

import Foundation

@frozen
public enum Result<T> {
    case success(T)
    case failure(NetworkingError)
}
