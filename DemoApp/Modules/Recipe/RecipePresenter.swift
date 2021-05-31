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
    
    func recievedData(recipe: Drink) {
        view?.showRecipe(recipe)
    }
    
    func requestFailed(with message: String) {
        view?.showError(message)
    }
    
    func recievedImage(_ image: UIImage) {
        view?.showImage(image)
    }
}
