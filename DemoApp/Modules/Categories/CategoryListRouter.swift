//
//  CategoryListRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class CategoryListRouter: CategoryListPresenterToRouterProtocol {
    weak var view: CategoryListViewController?
    
    init(view: CategoryListViewController) {
        self.view = view
    }
    
    static func createModule() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CategoryListViewController") as! CategoryListViewController
        
        let presenter: CategoryListViewToPresenterProtocol & CategoryListInteractorToPresenterProtocol = CategoryListPresenter()
        let interactor: CategoryListPresenterToInteractorProtocol = CategoryListInteractor()
        let router: CategoryListPresenterToRouterProtocol = CategoryListRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func showDrinksForSelectedCategory(_ category: Category) {
        let viewController = CategoryDetailRouter.createModule()
        viewController.categoryName = category.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
