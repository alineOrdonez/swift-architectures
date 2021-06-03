//
//  View+Extension.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 02/06/21.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
