//
//  RecipeRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 30/05/21.
//

import Foundation
import UIKit

class RecipeRouter: RecipePresenterToRouterProtocol {
    
    static func createModule() -> RecipeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RecipeViewController") as! RecipeViewController
        
        let repository: Repository = RepoType.current.repository()
        var presenter: RecipeViewToPresenterProtocol & RecipeInteractorToPresenterProtocol = RecipePresenter()
        var interactor: RecipePresenterToInteractorProtocol = RecipeInteractor(repository: repository)
        let router: RecipePresenterToRouterProtocol = RecipeRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}
