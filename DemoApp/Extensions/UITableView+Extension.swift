//
//  UITableView+Extension.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 28/06/21.
//

import UIKit

extension UITableView {
    
    func addBackgroundView(with message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 30, width: self.bounds.size.width, height: 50))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        
        let image = UIImage(named: "placeholder")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 80, width: self.bounds.size.width, height: self.bounds.size.height/3))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: self.bounds)
        containerView.addSubview(messageLabel)
        containerView.addSubview(imageView)
        
        self.backgroundView = containerView
        self.separatorStyle = .none
        
        if UIAccessibility.isVoiceOverRunning {
            accessibilityElements = [containerView, messageLabel, imageView]
            isAccessibilityElement = true
            accessibilityLabel = message
        }
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
