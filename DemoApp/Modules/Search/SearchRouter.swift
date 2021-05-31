//
//  SearchRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class SearchRouter: SearchPresenterToRouterProtocol {
    
    static func createModule() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        
        let presenter: SearchViewToPresenterProtocol & SearchInteractorToPresenterProtocol = SearchPresenter()
        let interactor: SearchPresenterToInteractorProtocol = SearchInteractor()
        let router: SearchPresenterToRouterProtocol = SearchRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func showRecipe(for id: String, navigationController: UINavigationController) {
        let viewController = RecipeRouter.createModule()
        viewController.recipeId = id
        navigationController.pushViewController(viewController, animated: true)
    }
}
