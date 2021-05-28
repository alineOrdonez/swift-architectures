//
//  Bluring.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 28/05/21.
//

import Foundation
import UIKit

protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.3) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)

        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha

        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Bluring {}
