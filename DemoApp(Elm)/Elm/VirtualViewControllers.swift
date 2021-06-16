//
//  VirtualViewControllers.swift
//  DemoApp(Elm)
//
//  Created by Aline Arely Ordonez Garcia on 08/06/21.
//

import UIKit
import Foundation

struct NavigationController<Message> {
    var viewControllers: [NavigationItem<Message>]
    var back: Message?
    var popDetail: Message?
    
    init(viewControllers: [NavigationItem<Message>], back: Message? = nil, popDetail: Message? = nil) {
        self.viewControllers = viewControllers
        self.back = back
        self.popDetail = popDetail
    }
    
    func map<B>(_ transform: @escaping (Message) -> B) -> NavigationController<B> {
        return NavigationController<B>(viewControllers: viewControllers.map { vc in vc.map(transform) }, back: back.map(transform), popDetail: popDetail.map(transform))
    }
}

struct Modal<Message> {
    let viewController: ViewController<Message>
    let presentationStyle: UIModalPresentationStyle
    
    func map<B>(_ transform: @escaping (Message) -> B) -> Modal<B> {
        return Modal<B>(viewController: viewController.map(transform), presentationStyle: presentationStyle)
    }
}

struct NavigationItem<Message> {
    let title: String
    let leftBarButtonItem: BarButtonItem<Message>?
    let rightBarButtonItems: [BarButtonItem<Message>]
    let leftItemsSupplementsBackButton: Bool
    let viewController: ViewController<Message>
    
    init(title: String = "", leftBarButtonItem: BarButtonItem<Message>? = nil, rightBarButtonItems: [BarButtonItem<Message>] = [], leftItemsSupplementsBackButton: Bool = false, viewController: ViewController<Message>) {
        self.title = title
        self.leftBarButtonItem = leftBarButtonItem
        self.rightBarButtonItems = rightBarButtonItems
        self.leftItemsSupplementsBackButton = leftItemsSupplementsBackButton
        self.viewController = viewController
    }
    
    func map<B>(_ transform: @escaping (Message) -> B) -> NavigationItem<B> {
        return NavigationItem<B>(title: title, leftBarButtonItem: leftBarButtonItem?.map(transform), rightBarButtonItems: rightBarButtonItems.map { btn in btn.map(transform) }, leftItemsSupplementsBackButton: leftItemsSupplementsBackButton, viewController: viewController.map(transform))
    }
}

indirect enum ViewController<Message> {
    case tableViewController(TableView<Message>)
    case navigationController(NavigationController<Message>)
    
    func map<B>(_ transform: @escaping (Message) -> B) -> ViewController<B> {
        switch self {
        case .navigationController(let nc): return .navigationController(nc.map(transform))
        case .tableViewController(let tc): return .tableViewController(tc.map(transform))
        }
    }
    
    static func viewController(_ view: View<Message>, useLayoutGuide: Bool = true) -> ViewController {
        return ._viewController(view, useLayoutGuide: useLayoutGuide)
    }
    
}


