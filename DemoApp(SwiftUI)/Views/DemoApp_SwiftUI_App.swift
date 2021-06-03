//
//  DemoApp_SwiftUI_App.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

@main
struct DemoApp_SwiftUI_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

