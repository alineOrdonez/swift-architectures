//
//  FavoritesProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 16/06/21.
//

import UIKit

protocol FavoritesViewToPresenterProtocol {
    var view: FavoritesPresenterToViewProtocol? { get set }
    var interactor: FavoritesPresenterToInteractorProtocol? { get set }
    var router: FavoritesPresenterToRouterProtocol? { get set }
    
    func fetchDrinks()
    func downloadImage(from url: URL)
    func showRecipe(for id: String, navigationController: UINavigationController)
}

protocol FavoritesPresenterToViewProtocol {
    var presenter: FavoritesViewToPresenterProtocol? { get set }
    
    func showData(_ drinks: [Drink])
    func showError(_ message: String)
    func showImage(_ image: Data, from url: String)
}

protocol FavoritesPresenterToRouterProtocol {
    static func createModule() -> UINavigationController
    func showRecipe(for id: String, navigationController: UINavigationController)
}

protocol FavoritesPresenterToInteractorProtocol {
    var presenter: FavoritesInteractorToPresenterProtocol? { get set }
    
    func getDrinks()
    func downloadImage(from url: URL)
}

protocol FavoritesInteractorToPresenterProtocol {
    
    func recievedData(drinks: [Drink])
    func requestFailed(with message: String)
    func recievedImage(_ image: Data, from url: String)
}
