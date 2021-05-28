//
//  String+Extension.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 28/05/21.
//

import Foundation

extension String {
    
    func formatName() -> String {
        return self.replacingOccurrences(of: " ", with:"").replacingOccurrences(of: "/", with:"-")
    }
}
