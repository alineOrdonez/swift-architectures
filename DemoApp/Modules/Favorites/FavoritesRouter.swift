//
//  FavoritesRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 16/06/21.
//

import UIKit

class FavoritesRouter: FavoritesPresenterToRouterProtocol {
    
    static func createModule() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
        let repository: Repository = InMemoryRepository()
        
        var presenter: FavoritesViewToPresenterProtocol & FavoritesInteractorToPresenterProtocol = FavoritesPresenter()
        var interactor: FavoritesPresenterToInteractorProtocol = FavoritesInteractor(repository: repository)
        let router: FavoritesPresenterToRouterProtocol = FavoritesRouter()
        
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
