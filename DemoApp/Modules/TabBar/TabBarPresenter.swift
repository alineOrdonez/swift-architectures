//
//  TabBarPresenter.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

class TabBarPresenter: TabBarViewToPresenterProtocol, TabBarInteractorToPresenterProtocol {
    var view: TabBarPresenterToViewProtocol?
    var interactor: TabBarPresenterToInteractorProtocol?
    var router: TabBarPresenterToRouterProtocol?
    
}
