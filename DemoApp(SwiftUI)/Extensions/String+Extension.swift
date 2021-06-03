//
//  String+Extension.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/06/21.
//

import Foundation

extension String {
    
    func formatName() -> String {
        return self.replacingOccurrences(of: " ", with:"").replacingOccurrences(of: "/", with:"-")
    }
}
