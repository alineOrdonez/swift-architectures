//
//  CategoryListPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

class CategoryListPresenter: CategoryListViewToPresenterProtocol, CategoryListInteractorToPresenterProtocol {
    
    var view: CategoryListPresenterToViewProtocol?
    var interactor: CategoryListPresenterToInteractorProtocol?
    var router: CategoryListPresenterToRouterProtocol?
    
    func fetchCategories() {
        interactor?.getCategories()
    }
    
    func showDrinksForSelectedCategory(_ category: Category) {
        router?.showDrinksForSelectedCategory(category)
    }
    
    func recievedData(categories: [Category]) {
        view?.showData(categories)
    }
    
    func requestFailed(with message: String) {
        view?.showError(message)
    }
}
