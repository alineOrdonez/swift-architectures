//
//  CategoryDetailInteractor.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation


class CategoryDetailInteractor: CategoryDetailPresenterToInteractorProtocol {
    
    var presenter: CategoryDetailInteractorToPresenterProtocol?
    var manager: NetworkManager
    
    init(manager: NetworkManager = NetworkManager()) {
        self.manager = manager
    }
    
    func getDrinks(by category: String) {
        let request = RecipeRequest(path: "filter", search: "c=\(category)")
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
