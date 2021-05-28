//
//  SearchPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

class SearchPresenter: SearchViewToPresenterProtocol, SearchInteractorToPresenterProtocol {
    var view: SearchPresenterToViewProtocol?
    var interactor: SearchPresenterToInteractorProtocol?
    var router: SearchPresenterToRouterProtocol?
    
    func searchRecipe(by name: String) {
        interactor?.searchRecipes(by: name)
    }
    
    func recievedData(drinks: [Drink]) {
        view?.showData(drinks)
    }
    func requestFailed(with message: String) {
        view?.showError(message)
    }
}
