//
//  CategoryDetailService.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/06/21.
//

import Foundation
import Combine

final class CategoryDetailService: NetworkAPIProtocol {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func getDrinks(_ endpoint: DrinkEndpoint) -> AnyPublisher<DrinkList, Error> {
        execute(request: endpoint.request, responseType: DrinkList.self, retries: 1)
    }
}
