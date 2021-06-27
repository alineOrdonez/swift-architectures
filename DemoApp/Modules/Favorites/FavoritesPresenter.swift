//
//  FavoritesPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 16/06/21.
//

import Foundation
import UIKit

class FavoritesPresenter: FavoritesViewToPresenterProtocol, FavoritesInteractorToPresenterProtocol {
    
    var categoryName: String?
    
    var view: FavoritesPresenterToViewProtocol?
    var interactor: FavoritesPresenterToInteractorProtocol?
    var router: FavoritesPresenterToRouterProtocol?
    
    func fetchDrinks() {
        interactor?.getDrinks()
    }
    
    func downloadImage(from url: URL) {
        interactor?.downloadImage(from: url)
    }
    
    func showRecipe(for id: String, navigationController: UINavigationController) {
        router?.showRecipe(for: id, navigationController: navigationController)
    }
    
    func recievedData(drinks: [FavoritesEntity]) {
        view?.showData(drinks)
    }
    func requestFailed(with message: String) {
        view?.showError(message)
    }
    
    // MARK: - Download image
    func recievedImage(_ image: Data, from url: String) {
        view?.showImage(image, from: url)
    }
}
