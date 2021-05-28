//
//  CategoryListProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

protocol CategoryListViewToPresenterProtocol {
    var view: CategoryListPresenterToViewProtocol? { get set }
    var interactor: CategoryListPresenterToInteractorProtocol? { get set }
    var router: CategoryListPresenterToRouterProtocol? { get set }
    
    func fetchCategories()
}

protocol CategoryListPresenterToViewProtocol {
    var presenter: CategoryListViewToPresenterProtocol? { get set }
    
    func showData(_ drinks: [Category])
    func showError(_ message: String)
}

protocol CategoryListPresenterToRouterProtocol {
    static func createModule() -> UINavigationController
}

protocol CategoryListPresenterToInteractorProtocol {
    var presenter: CategoryListInteractorToPresenterProtocol? { get set }
    
    func getCategories()
}

protocol CategoryListInteractorToPresenterProtocol {
    
    func recievedData(drinks: [Category])
    func requestFailed(with message: String)
}
