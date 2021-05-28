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
        
        var presenter: SearchViewToPresenterProtocol & SearchInteractorToPresenterProtocol = SearchPresenter()
        var interactor: SearchPresenterToInteractorProtocol = SearchInteractor()
        let router: SearchPresenterToRouterProtocol = SearchRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        
        return UINavigationController(rootViewController: viewController)
    }
}
