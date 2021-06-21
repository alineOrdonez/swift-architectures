//
//  Array+Extension.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 18/06/21.
//

import Foundation

extension Array {
    func last(_ n: Int) -> ArraySlice<Element> {
        return self[endIndex-n..<endIndex]
    }
}
