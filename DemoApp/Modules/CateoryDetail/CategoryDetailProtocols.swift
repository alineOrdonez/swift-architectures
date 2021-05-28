//
//  CategoryDetailProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

protocol CategoryDetailViewToPresenterProtocol {
    var view: CategoryDetailPresenterToViewProtocol? { get set }
    var interactor: CategoryDetailPresenterToInteractorProtocol? { get set }
    var router: CategoryDetailPresenterToRouterProtocol? { get set }
    
    func fetchDrinks(by category: String)
}

protocol CategoryDetailPresenterToViewProtocol {
    var presenter: CategoryDetailViewToPresenterProtocol? { get set }
    var categoryName: String? { get }
    
    func showData(_ drinks: [Drink])
    func showError(_ message: String)
}

protocol CategoryDetailPresenterToRouterProtocol {
    static func createModule() -> CategoryDetailViewController
}

protocol CategoryDetailPresenterToInteractorProtocol {
    var presenter: CategoryDetailInteractorToPresenterProtocol? { get set }
    
    func getDrinks(by category: String)
}

protocol CategoryDetailInteractorToPresenterProtocol {
    
    func recievedData(drinks: [Drink])
    func requestFailed(with message: String)
}
