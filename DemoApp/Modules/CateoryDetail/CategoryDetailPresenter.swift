//
//  CategoryDetailPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

class CategoryDetailPresenter: CategoryDetailViewToPresenterProtocol, CategoryDetailInteractorToPresenterProtocol {
    
    var categoryName: String?
    
    var view: CategoryDetailPresenterToViewProtocol?
    var interactor: CategoryDetailPresenterToInteractorProtocol?
    var router: CategoryDetailPresenterToRouterProtocol?
    
    func fetchDrinks(by category: String) {
        interactor?.getDrinks(by: category)
    }
    
    func downloadImage(from url: URL) {
        interactor?.downloadImage(from: url)
    }
    
    func showRecipe(for id: String, navigationController: UINavigationController) {
        router?.showRecipe(for: id, navigationController: navigationController)
    }
    
    func recievedData(drinks: [CategoryDetailEntity]) {
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
