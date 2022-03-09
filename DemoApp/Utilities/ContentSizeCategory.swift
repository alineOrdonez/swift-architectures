//
//  ContentSizeCategory.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 08/03/22.
//

import UIKit

struct ContentSizeCategory {
    var categorySizeNumber: Int
    var categoryContentSize: String
    
    init(category: UIContentSizeCategory) {
        categoryContentSize = category.rawValue
        switch categoryContentSize {
            case "UICTContentSizeCategoryXS":
                categorySizeNumber = 1
            case "UICTContentSizeCategoryS":
                categorySizeNumber = 2
            case "UICTContentSizeCategoryM":
                categorySizeNumber = 3
            case "UICTContentSizeCategoryL":
                categorySizeNumber = 4
            case "UICTContentSizeCategoryXL":
                categorySizeNumber = 5
            case "UICTContentSizeCategoryXXL":
                categorySizeNumber = 6
            case "UICTContentSizeCategoryXXXL":
                categorySizeNumber = 7
            case "UICTContentSizeCategoryAccessibilityM":
                categorySizeNumber = 8
            case "UICTContentSizeCategoryAccessibilityL":
                categorySizeNumber = 9
            case "UICTContentSizeCategoryAccessibilityXL":
                categorySizeNumber = 10
            case "UICTContentSizeCategoryAccessibilityXXL":
                categorySizeNumber = 11
            case "UICTContentSizeCategoryAccessibilityXXXL":
                categorySizeNumber = 12
            default:
                categorySizeNumber = 1
        }
    }
}
