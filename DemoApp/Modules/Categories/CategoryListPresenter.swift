//
//  CategoryListPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

class CategoryListPresenter: CategoryListViewToPresenterProtocol, CategoryListInteractorToPresenterProtocol {
    
    var view: CategoryListPresenterToViewProtocol?
    var interactor: CategoryListPresenterToInteractorProtocol?
    var router: CategoryListPresenterToRouterProtocol?
    
    func fetchCategories() {
        interactor?.getCategories()
    }
    
    func showDrinks(for selectedCategory: CategoryEntity, navigationController: UINavigationController) {
        router?.showDrinks(for: selectedCategory, navigationController: navigationController)
    }
    
    func recievedData(categories: [CategoryEntity]) {
        view?.showData(categories)
    }
    
    func requestFailed(with message: String) {
        view?.showError(message)
    }
}
