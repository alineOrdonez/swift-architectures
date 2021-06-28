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
        repository = RepoType.current.repository()
        repository.list { result in
            switch result {
            case .success(let drinks):
                let entities = drinks.map( {FavoritesEntity(id: $0.id, name: $0.name, thumb: $0.thumb, category: $0.category)} )
                self.presenter?.recievedData(drinks: entities)
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
        
        if url.isFileURL, let image = repository.getImage(from: url) {
            self.presenter?.recievedImage(image, from: url.absoluteString)
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
