//
//  CategoryListService.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 02/05/21.
//

import Foundation
import Combine

final class CategoryListService: NetworkAPIProtocol {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func getCategories(_ endpoint: DrinkEndpoint) -> AnyPublisher<CategoryList, Error> {
        execute(request: endpoint.request, responseType: CategoryList.self, retries: 1)
    }
}
