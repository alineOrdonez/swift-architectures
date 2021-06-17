//
//  RecipeProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 30/05/21.
//

import UIKit

protocol RecipeViewToPresenterProtocol {
    var view: RecipePresenterToViewProtocol? { get set }
    var interactor: RecipePresenterToInteractorProtocol? { get set }
    var router: RecipePresenterToRouterProtocol? { get set }
    
    func getRecipe(with id: String)
    func downloadImage(from url: URL)
    func isFavorite(drink: String)
    func addRemove(drink: Drink, isFavorite: Bool)
}

protocol RecipePresenterToViewProtocol {
    var presenter: RecipeViewToPresenterProtocol? { get set }
    var recipeId: String { get }
    
    func showRecipe(_ recipe: Drink)
    func showError(_ message: String)
    func showImage(_ image: UIImage)
    func foundFavoriteRecipe(isFavorite: Bool)
    func didCompleteAction()
}

protocol RecipePresenterToRouterProtocol {
    static func createModule() -> RecipeViewController
}

protocol RecipePresenterToInteractorProtocol {
    var presenter: RecipeInteractorToPresenterProtocol? { get set }
    
    func getRecipe(with Id: String)
    func downloadImage(from url: URL)
    func isFavorite(drink: String)
    func addRemove(drink: Drink, isFavorite: Bool)
}

protocol RecipeInteractorToPresenterProtocol {
    
    func recievedData(recipe: Drink)
    func requestFailed(with message: String)
    func recievedImage(_ image: UIImage)
    func foundFavoriteRecipe(isFavorite: Bool)
    func didCompleteAction()
}
