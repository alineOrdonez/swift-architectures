//
//  Driver.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

import Foundation
import UIKit

public protocol Component {
    associatedtype Message: Equatable
    mutating func send(_: Message) -> [Command<Message>]
    var viewController: ViewController<Message> { get }
}

final public class Driver<Model> where Model: Component {
    private var model: Model
    private var strongReferences: StrongReferences = StrongReferences()
    public private(set) var viewController: UIViewController = UIViewController()
    
    public init(_ initial: Model, commands: [Command<Model.Message>] = []) {
        model = initial
        strongReferences = model.viewController.render(callback: self.asyncSend, change: &viewController)
        for command in commands {
            interpret(command: command)
        }
    }
    
    public func send(action: Model.Message) {
        let commands = model.send(action)
        refresh()
        for command in commands {
            interpret(command: command)
        }
    }
    
    func asyncSend(action: Model.Message) {
        DispatchQueue.main.async {
            self.send(action: action)
        }
    }
    
    func interpret(command: Command<Model.Message>) {
        command.interpret(viewController: viewController, callback: self.asyncSend)
    }
    
    func refresh() {
        strongReferences = model.viewController.render(callback: self.asyncSend, change: &viewController)
    }
}
