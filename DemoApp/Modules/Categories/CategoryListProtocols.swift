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
    func showDrinksForSelectedCategory(_ category: Category)
}

protocol CategoryListPresenterToViewProtocol: AnyObject {
    var presenter: CategoryListViewToPresenterProtocol? { get set }
    
    func showData(_ categories: [Category])
    func showError(_ message: String)
}

protocol CategoryListPresenterToRouterProtocol: AnyObject {
    static func createModule() -> UINavigationController
    
    func showDrinksForSelectedCategory(_ category: Category)
}

protocol CategoryListPresenterToInteractorProtocol: AnyObject {
    var presenter: CategoryListInteractorToPresenterProtocol? { get set }
    
    func getCategories()
}

protocol CategoryListInteractorToPresenterProtocol: AnyObject {
    
    func recievedData(categories: [Category])
    func requestFailed(with message: String)
}
