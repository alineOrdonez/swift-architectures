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
                guard var drink = list.drinks?.first else {
                    let error = NetworkingError.invalidResponse.localizedDescription
                    self.presenter?.requestFailed(with: error)
                    return
                }
                self.addIngredientes(drink: &drink)
                self.presenter?.recievedData(recipe: drink)
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
    
    func addRemove(drink: Drink, isFavorite: Bool) {
        if isFavorite {
            repository.add(drink) { [weak self] result in
                switch result {
                case .success(_):
                    self?.presenter?.didCompleteAction()
                case .failure(let error):
                    self?.presenter?.requestFailed(with: error.localizedDescription)
                }
            }
        } else {
            repository.delete(drink) { [weak self] result in
                switch result {
                case .success(_):
                    self?.presenter?.didCompleteAction()
                case .failure(let error):
                    self?.presenter?.requestFailed(with: error.localizedDescription)
                }
            }
        }
    }
    
    func addIngredientes( drink: inout Drink) {
        let ingredients: [String] = [drink.strIngredient1, drink.strIngredient2, drink.strIngredient3, drink.strIngredient4, drink.strIngredient5, drink.strIngredient6, drink.strIngredient7].compactMap({$0}).filter({ !$0.isEmpty })
        
        let measures: [String] = [drink.strMeasure1, drink.strMeasure2, drink.strMeasure3, drink.strMeasure4, drink.strMeasure5, drink.strMeasure6, drink.strMeasure7].compactMap { measure in
            guard let measure = measure, !measure.isEmpty else {
                return "-"
            }
            return measure
        }
        var array = [[String: String]]()
        
        for (index, element) in ingredients.enumerated() {
            let dictionary = [element: measures[index]]
            array.append(dictionary)
        }
        drink.listOfIngredients = array
    }
    
}
