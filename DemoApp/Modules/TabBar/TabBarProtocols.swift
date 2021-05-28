//
//  TabBarProtocols.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

protocol TabBarViewToPresenterProtocol {
    var view: TabBarPresenterToViewProtocol? { get set }
    var interactor: TabBarPresenterToInteractorProtocol? { get set }
    var router: TabBarPresenterToRouterProtocol? { get set }
}

protocol TabBarPresenterToViewProtocol {
    var presenter: TabBarViewToPresenterProtocol? { get set }
}

protocol TabBarPresenterToRouterProtocol {
    static func createModule() -> UITabBarController
}

protocol TabBarPresenterToInteractorProtocol {
    var presenter: TabBarInteractorToPresenterProtocol? { get set }
}

protocol TabBarInteractorToPresenterProtocol {
}
