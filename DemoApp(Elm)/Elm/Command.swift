//
//  Command.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

import Foundation
import UIKit

public enum Command<A: Equatable> {
    // Networking
    case request(URLRequest, available: (Data?) -> A)
    
    public func map<B>(_ f: @escaping (A) -> B) -> Command<B> {
        switch self {
        case let .request(request, available):
            return .request(request, available: { result in f(available(result))})
        }
    }
}

extension Command {
    func interpret(viewController: UIViewController, callback: @escaping (A) -> Void) {
        switch self {
        case let .request(request, available: available):
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                callback(available(data))
            }.resume()
        }
    }
}
