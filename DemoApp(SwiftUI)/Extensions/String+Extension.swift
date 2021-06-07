//
//  String+Extension.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/05/21.
//

import Foundation

extension String {

    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    func formatName() -> String {
        return self.replacingOccurrences(of: " ", with:"").replacingOccurrences(of: "/", with:"-")
    }
}
