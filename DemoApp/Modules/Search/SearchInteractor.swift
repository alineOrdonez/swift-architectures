//
//  SearchInteractor.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation


class SearchInteractor: SearchPresenterToInteractorProtocol {
    var presenter: SearchInteractorToPresenterProtocol?
    var manager: NetworkManager
    
    init(manager: NetworkManager = NetworkManager()) {
        self.manager = manager
    }
    
    func searchRecipes(by name: String) {
        let request = RecipeRequest(path: "search", search: "s=\(name)")
        manager.executeRequest(request, responseType: DrinkList.self) { response in
            switch response {
            case .success(let list):
                guard let drinks = list.drinks else {
                    let error = NetworkingError.invalidResponse.localizedDescription
                    self.presenter?.requestFailed(with: error)
                    return
                }
                self.presenter?.recievedData(drinks: drinks)
            case .failure(let error):
                self.presenter?.requestFailed(with: error.localizedDescription)
            }
        }
    }
    
}
