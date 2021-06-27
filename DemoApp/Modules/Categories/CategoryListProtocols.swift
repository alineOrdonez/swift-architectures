//
//  CategoryListProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

protocol CategoryListViewToPresenterProtocol: AnyObject {
    var view: CategoryListPresenterToViewProtocol? { get set }
    var interactor: CategoryListPresenterToInteractorProtocol? { get set }
    var router: CategoryListPresenterToRouterProtocol? { get set }
    
    func fetchCategories()
    func showDrinks(for selectedCategory: CategoryEntity, navigationController: UINavigationController)
}

protocol CategoryListPresenterToViewProtocol: AnyObject {
    var presenter: CategoryListViewToPresenterProtocol? { get set }
    
    func showData(_ categories: [CategoryEntity])
    func showError(_ message: String)
}

protocol CategoryListPresenterToRouterProtocol: AnyObject {
    static func createModule() -> UINavigationController
    
    func showDrinks(for selectedCategory: CategoryEntity, navigationController: UINavigationController)
}

protocol CategoryListPresenterToInteractorProtocol: AnyObject {
    var presenter: CategoryListInteractorToPresenterProtocol? { get set }
    
    func getCategories()
}

protocol CategoryListInteractorToPresenterProtocol: AnyObject {
    
    func recievedData(categories: [CategoryEntity])
    func requestFailed(with message: String)
}
