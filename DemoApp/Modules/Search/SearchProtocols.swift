//
//  SearchProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

protocol SearchViewToPresenterProtocol: AnyObject {
    var view: SearchPresenterToViewProtocol? { get set }
    var interactor: SearchPresenterToInteractorProtocol? { get set }
    var router: SearchPresenterToRouterProtocol? { get set }
    
    func searchRecipe(by name: String)
    func downloadImage(from url: URL)
    func showRecipe(for id: String, navigationController: UINavigationController) 
}

protocol SearchPresenterToViewProtocol: AnyObject {
    var presenter: SearchViewToPresenterProtocol? { get set }
    
    func showData(_ drinks: [Drink])
    func showError(_ message: String)
    
    func showImage(_ image: Data, from url: String)
}

protocol SearchPresenterToRouterProtocol:AnyObject {
    static func createModule() -> UINavigationController
    func showRecipe(for id: String, navigationController: UINavigationController) 
}

protocol SearchPresenterToInteractorProtocol: AnyObject {
    var presenter: SearchInteractorToPresenterProtocol? { get set }
    
    func searchRecipes(by name: String)
    func downloadImage(from url: URL)
}

protocol SearchInteractorToPresenterProtocol: AnyObject {
    
    func recievedData(drinks: [Drink])
    func requestFailed(with message: String)
    
    func recievedImage(_ image: Data, from url: String)
}
