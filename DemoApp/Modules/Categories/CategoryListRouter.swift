//
//  CategoryListRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class CategoryListRouter: CategoryListPresenterToRouterProtocol {
    
    static func createModule() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CategoryListViewController") as! CategoryListViewController
        
        var presenter: CategoryListViewToPresenterProtocol & CategoryListInteractorToPresenterProtocol = CategoryListPresenter()
        var interactor: CategoryListPresenterToInteractorProtocol = CategoryListInteractor()
        let router: CategoryListPresenterToRouterProtocol = CategoryListRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        
        return UINavigationController(rootViewController: viewController)
    }
}
