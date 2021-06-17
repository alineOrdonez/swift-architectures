//
//  CategoryDetailRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class CategoryDetailRouter: CategoryDetailPresenterToRouterProtocol {
    
    static func createModule() -> CategoryDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CategoryDetailViewController") as! CategoryDetailViewController
        
        var presenter: CategoryDetailViewToPresenterProtocol & CategoryDetailInteractorToPresenterProtocol = CategoryDetailPresenter()
        var interactor: CategoryDetailPresenterToInteractorProtocol = CategoryDetailInteractor()
        let router: CategoryDetailPresenterToRouterProtocol = CategoryDetailRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
    
    func showRecipe(for id: String, navigationController: UINavigationController) {
        let viewController = RecipeRouter.createModule()
        viewController.recipeId = id
        navigationController.pushViewController(viewController, animated: true)
    }
}
