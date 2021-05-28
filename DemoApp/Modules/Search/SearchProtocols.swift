//
//  SearchProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

protocol SearchViewToPresenterProtocol {
    var view: SearchPresenterToViewProtocol? { get set }
    var interactor: SearchPresenterToInteractorProtocol? { get set }
    var router: SearchPresenterToRouterProtocol? { get set }
    
    func searchRecipe(by name: String)
}

protocol SearchPresenterToViewProtocol {
    var presenter: SearchViewToPresenterProtocol? { get set }
    
    func showData(_ drinks: [Drink])
    func showError(_ message: String)
}

protocol SearchPresenterToRouterProtocol {
    static func createModule() -> UINavigationController
}

protocol SearchPresenterToInteractorProtocol {
    var presenter: SearchInteractorToPresenterProtocol? { get set }
    
    func searchRecipes(by name: String)
}

protocol SearchInteractorToPresenterProtocol {
    
    func recievedData(drinks: [Drink])
    func requestFailed(with message: String)
}
