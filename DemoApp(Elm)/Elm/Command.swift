//
//  Command.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

import Foundation
import UIKit

public enum Command<A: Equatable> {
    // Custom
    
    // ViewControllers
    case modalTextAlert(title: String, accept: String, cancel: String, convert: (String?) -> A)
    case modalAlert(title: String, accept: String)
    
    // Networking
    case request(URLRequest, available: (Data?) -> A)
    
    public func map<B>(_ f: @escaping (A) -> B) -> Command<B> {
        switch self {
        case let .modalTextAlert(title, accept, cancel, convert):
            return .modalTextAlert(title: title, accept: accept, cancel: cancel, convert: { f(convert($0)) })
        case let .modalAlert(title: title, accept: accept):
            return .modalAlert(title: title, accept: accept)
        case let .request(request, available):
            return .request(request, available: { result in f(available(result))})
        }
    }
}

extension Command {
    func interpret(viewController: UIViewController!, callback: @escaping (A) -> ()) {
        switch self {
        case let .modalTextAlert(title: title, accept: accept, cancel: cancel, convert: convert):
            viewController.modalTextAlert(title: title, accept: accept, cancel: cancel, callback: { str in
                callback(convert(str))
            })
        case let .modalAlert(title: title, accept: accept):
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: accept, style: .default, handler: nil))
            let vc: UIViewController = viewController.presentedViewController ?? viewController
            vc.present(alert, animated: true, completion: nil)
        case let .request(request, available: available):
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                callback(available(data))
            }.resume()
        }
    }
}
