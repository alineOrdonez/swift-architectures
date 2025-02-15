//
//  RecipePresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 30/05/21.
//

import Foundation
import UIKit

class RecipePresenter: RecipeViewToPresenterProtocol, RecipeInteractorToPresenterProtocol {
    
    var view: RecipePresenterToViewProtocol?
    var interactor: RecipePresenterToInteractorProtocol?
    var router: RecipePresenterToRouterProtocol?
    
    func getRecipe(with id: String) {
        interactor?.getRecipe(with: id)
    }
    
    func downloadImage(from url: URL) {
        interactor?.downloadImage(from: url)
    }
    
    func isFavorite(drink: String) {
        interactor?.isFavorite(drink: drink)
    }
    
    func addRemove(drink: RecipeEntity, isFavorite: Bool) {
        interactor?.addRemove(drink: drink, isFavorite: isFavorite)
    }
    
    func recievedData(recipe: RecipeEntity) {
        view?.showRecipe(recipe)
    }
    
    func requestFailed(with message: String) {
        view?.showError(message)
    }
    
    func recievedImage(_ image: Data) {
        view?.showImage(image)
    }
    
    func foundFavoriteRecipe(isFavorite: Bool) {
        view?.foundFavoriteRecipe(isFavorite: isFavorite)
    }
    
    func didCompleteAction() {
        view?.didCompleteAction()
    }
}
