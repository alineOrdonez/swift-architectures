//
//  RecipeService.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 07/06/21.
//

import Foundation
import Combine

final class RecipeService: NetworkAPIProtocol {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func getRecipe(_ endpoint: DrinkEndpoint) -> AnyPublisher<DrinkList, Error> {
        execute(request: endpoint.request, responseType: DrinkList.self, retries: 1)
    }
}
