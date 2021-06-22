//
//  FavoriteService.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Ordoñez Garcia on 21/06/21.
//

import Foundation
import Combine

final class FavoriteService: NetworkAPIProtocol {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func getDrinkById(_ endpoint: DrinkEndpoint) -> AnyPublisher<DrinkList, Error> {
        execute(request: endpoint.request, responseType: DrinkList.self, retries: 1)
    }
}
