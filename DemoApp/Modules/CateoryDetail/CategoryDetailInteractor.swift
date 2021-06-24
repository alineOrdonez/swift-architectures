//
//  CategoryDetailInteractor.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit


class CategoryDetailInteractor: CategoryDetailPresenterToInteractorProtocol {
    
    var presenter: CategoryDetailInteractorToPresenterProtocol?
    var manager: NetworkManager
    
    let imageCache = NSCache<AnyObject, UIImage>()
    
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
    
    func downloadImage(from url: URL) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject), let data = imageFromCache.jpegData(compressionQuality: 1.0) {
            self.presenter?.recievedImage(data, from: url.absoluteString)
            return
        }
        
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
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async() { [weak self] in
                    let error = NetworkingError.invalidResponse.localizedDescription
                    self?.presenter?.requestFailed(with: error)
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.imageCache.setObject(image, forKey: url as AnyObject)
                self?.presenter?.recievedImage(data, from: url.absoluteString)
            }
        }
    }
}
