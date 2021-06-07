//
//  ActivityIndicator.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 01/05/21.
//

import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
