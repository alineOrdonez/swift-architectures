//
//  Command.swift
//  DemoApp(Elm)
//
//  Created by Aline Arely Ordonez Garcia on 08/06/21.
//

import UIKit

struct Context<Message> {
    let viewController: UIViewController
    let send: (Message) -> ()
    
    func map<B>(_ transform: @escaping (B) -> Message) -> Context<B> {
        return Context<B>(viewController: viewController, send: {
            self.send(transform($0))
        })
    }
}

struct Command<Message> {
    let run: (Context<Message>) -> ()
    
    func map<B>(_ transform: @escaping (Message) -> B) -> Command<B> {
        return Command<B> { context in
            self.run(context.map(transform))
        }
    }
}
