//
//  TabBarRouter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit



class TabBarRouter: TabBarPresenterToRouterProtocol {
    
    typealias SubModules = (search: UIViewController, category: UIViewController, favorite: UIViewController)
    
    static func createModule() -> UITabBarController {
        let submodules = (search: SearchRouter.createModule(), category: CategoryListRouter.createModule(), favorite: FavoritesRouter.createModule())
        let tabs = tabs(using: submodules)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateInitialViewController() as! TabBarController
        
        var interactor: TabBarPresenterToInteractorProtocol = TabBarInteractor()
        let router: TabBarPresenterToRouterProtocol = TabBarRouter()
        var presenter: TabBarViewToPresenterProtocol & TabBarInteractorToPresenterProtocol = TabBarPresenter()
        
        presenter.view = tabBarController
        presenter.interactor = interactor
        presenter.router = router
        tabBarController.presenter = presenter
        interactor.presenter = presenter
        
        tabBarController.viewControllers = [tabs.search, tabs.category, tabs.favorite]
        return tabBarController
    }
    
    static func tabs(using submodules: SubModules) -> AppTabs {
        
        let searchTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 101)
        submodules.search.tabBarItem = searchTabBarItem
        
        let categoryTabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "square.grid.2x2"), tag: 102)
        submodules.category.tabBarItem = categoryTabBarItem
        
        let favoriteTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 103)
        submodules.favorite.tabBarItem = favoriteTabBarItem
        
        return (search: submodules.search, category: submodules.category, favorite: submodules.favorite)
    }
}
