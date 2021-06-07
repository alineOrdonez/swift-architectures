//
//  SearchService.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/05/21.
//

import Foundation
import Combine

final class SearchService: NetworkAPIProtocol {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func searchRecipe(_ endpoint: DrinkEndpoint) -> AnyPublisher<DrinkList, Error> {
        execute(request: endpoint.request, responseType: DrinkList.self, retries: 1)
    }
}
