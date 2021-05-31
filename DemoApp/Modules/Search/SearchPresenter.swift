//
//  SearchPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

class SearchPresenter: SearchViewToPresenterProtocol, SearchInteractorToPresenterProtocol {
    var view: SearchPresenterToViewProtocol?
    var interactor: SearchPresenterToInteractorProtocol?
    var router: SearchPresenterToRouterProtocol?
    
    func searchRecipe(by name: String) {
        interactor?.searchRecipes(by: name)
    }
    
    func downloadImage(from url: URL) {
        interactor?.downloadImage(from: url)
    }
    
    func showRecipe(for id: String, navigationController: UINavigationController)  {
        router?.showRecipe(for: id, navigationController: navigationController)
    }
    
    // MARK: - Search result
    func recievedData(drinks: [Drink]) {
        view?.showData(drinks)
    }
    func requestFailed(with message: String) {
        view?.showError(message)
    }
    
    // MARK: - Download image
    func recievedImage(_ image: UIImage, from url: String) {
        view?.showImage(image, from: url)
    }
}
