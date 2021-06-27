//
//  RecipeInteractor.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 30/05/21.
//

import Foundation
import UIKit

class RecipeInteractor: RecipePresenterToInteractorProtocol {
    
    var presenter: RecipeInteractorToPresenterProtocol?
    var manager: NetworkManager
    
    private var repository: Repository
    
    init(manager: NetworkManager = NetworkManager(), repository: Repository) {
        self.manager = manager
        self.repository = repository
    }
    
    func getRecipe(with id: String) {
        let request = RecipeRequest(path: "lookup", search: "i=\(id)")
        manager.executeRequest(request, responseType: DrinkList.self) { response in
            switch response {
            case .success(let list):
                guard let drink = list.drinks?.first else {
                    let error = NetworkingError.invalidResponse.localizedDescription
                    self.presenter?.requestFailed(with: error)
                    return
                }
                let entity = RecipeEntity(drink: drink)
                self.presenter?.recievedData(recipe: entity)
            case .failure(let error):
                self.presenter?.requestFailed(with: error.localizedDescription)
            }
        }
    }
    
    func downloadImage(from url: URL) {
        manager.getData(from: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async() { [weak self] in
                    if let error = error {
                        self?.presenter?.requestFailed(with: error.localizedDescription)
                    } else {
                        let error = NetworkingError.invalidResponse.localizedDescription
                        self?.presenter?.requestFailed(with: error)
                    }
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.presenter?.recievedImage(data)
            }
        }
    }
    
    func isFavorite(drink: String) {
        repository.exist(id: drink) {[weak self] result in
            switch result {
            case .success(let exist):
                self?.presenter?.foundFavoriteRecipe(isFavorite: exist)
            case .failure(_):
                self?.presenter?.foundFavoriteRecipe(isFavorite: false)
            }
        }
    }
    
    func addRemove(drink: RecipeEntity, isFavorite: Bool) {
        
        let entity = FavoritesEntity(id: drink.id, name: drink.name, thumb: drink.thumb, category: drink.category)
        
        if isFavorite {
            repository.add(entity) { [weak self] result in
                switch result {
                case .success(_):
                    self?.presenter?.didCompleteAction()
                case .failure(let error):
                    self?.presenter?.requestFailed(with: error.localizedDescription)
                }
            }
        } else {
            repository.delete(entity) { [weak self] result in
                switch result {
                case .success(_):
                    self?.presenter?.didCompleteAction()
                case .failure(let error):
                    self?.presenter?.requestFailed(with: error.localizedDescription)
                }
            }
        }
    }
}
