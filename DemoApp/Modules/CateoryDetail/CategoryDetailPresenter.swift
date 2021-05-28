//
//  CategoryDetailPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

class CategoryDetailPresenter: CategoryDetailViewToPresenterProtocol, CategoryDetailInteractorToPresenterProtocol {
    
    var categoryName: String?
    
    var view: CategoryDetailPresenterToViewProtocol?
    var interactor: CategoryDetailPresenterToInteractorProtocol?
    var router: CategoryDetailPresenterToRouterProtocol?
    
    func fetchDrinks(by category: String) {
        interactor?.getDrinks(by: category)
    }
    
    func recievedData(drinks: [Drink]) {
        view?.showData(drinks)
    }
    func requestFailed(with message: String) {
        view?.showError(message)
    }
}
