//
//  CategoryListInteractor.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation

class CategoryListInteractor: CategoryListPresenterToInteractorProtocol {
    var presenter: CategoryListInteractorToPresenterProtocol?
    private var manager: NetworkManager
    
    init(manager: NetworkManager = NetworkManager()) {
        self.manager = manager
    }
    
    func getCategories() {
        let request = RecipeRequest(path: "list", search: "c=list")
        manager.executeRequest(request, responseType: CategoryList.self) {[weak self] result in
            switch result {
            case .success(let list):
                guard let categories = list.categories else {
                    let error = NetworkingError.invalidResponse.localizedDescription
                    self?.presenter?.requestFailed(with: error)
                    return
                }
                self?.presenter?.recievedData(categories: categories)
            case .failure(let error):
                self?.presenter?.requestFailed(with: error.localizedDescription)
            }
        }
    }
    
}
