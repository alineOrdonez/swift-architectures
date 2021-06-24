//
//  UIViewController+Extension.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

import UIKit

extension UIViewController {
    func modalTextAlert(title: String, accept: String = "Ok", cancel: String = "Cancel", callback: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
            callback(nil)
        })
        alert.addAction(UIAlertAction(title: accept, style: .default) { _ in
            callback(alert.textFields?.first?.text)
        })
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true)
    }
}
