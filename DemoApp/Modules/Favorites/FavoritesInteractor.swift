//
//  FavoritesInteractor.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 16/06/21.
//

import Foundation
import UIKit


class FavoritesInteractor: FavoritesPresenterToInteractorProtocol {
    
    var presenter: FavoritesInteractorToPresenterProtocol?
    var manager: NetworkManager
    private var repository: Repository
    
    let imageCache = NSCache<AnyObject, UIImage>()
    
    init(manager: NetworkManager = NetworkManager(), repository: Repository) {
        self.manager = manager
        self.repository = repository
    }
    
    func getDrinks() {
        repository.list { (drinks, error) in
            if let drinks = drinks {
                self.presenter?.recievedData(drinks: drinks)
            } else {
                self.presenter?.requestFailed(with: error!.localizedDescription)
            }
        }
    }
    
    func downloadImage(from url: URL) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
            self.presenter?.recievedImage(imageFromCache, from: url.absoluteString)
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
                self?.presenter?.recievedImage(image, from: url.absoluteString)
            }
        }
    }
}
