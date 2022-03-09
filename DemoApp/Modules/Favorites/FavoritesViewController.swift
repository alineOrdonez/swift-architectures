//
//  FavoritesViewController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 16/06/21.
//

import UIKit

class FavoritesViewController: UIViewController, FavoritesPresenterToViewProtocol {
    
    var presenter: FavoritesViewToPresenterProtocol?
    var drinks: [FavoritesEntity]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupAccessibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDrinks()
    }
    
    func setupUI() {
        self.title = "Favorites"
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        tableView.register(UINib(nibName: DrinkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DrinkTableViewCell.identifier)
        
        let item = UIBarButtonItem(image: UIImage(systemName: "cylinder.split.1x2")!, style: .plain, target: self, action: #selector(showRepositories(_:)))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @IBAction func showRepositories(_ sender: Any) {
        let alert = UIAlertController(title: "Choose your storage", message: "Where do you want to save your favorite drinks?", preferredStyle: .actionSheet)
        
        let coreDataAction = UIAlertAction(title: "Core Data", style: .default, handler: { action in
            RepoType.current = .coreData
            self.fetchDrinks()
        })
        let realmAction = UIAlertAction(title: "Realm", style: .default, handler: { action in
            RepoType.current = .realm
            self.fetchDrinks()
        })
        let localStorageAction = UIAlertAction(title: "Local Storage", style: .default, handler: { action in
            RepoType.current = .localStorage
            self.fetchDrinks()
        })
        let userDefaultsAction = UIAlertAction(title: "User Defaults", style: .default, handler: { action in
            RepoType.current = .userDefaults
            self.fetchDrinks()
        })
        let inMemoryStorageAction = UIAlertAction(title: "In Memory Storage", style: .default, handler: { action in
            RepoType.current = .inMemoryStorage
            self.fetchDrinks()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(coreDataAction)
        alert.addAction(realmAction)
        alert.addAction(localStorageAction)
        alert.addAction(userDefaultsAction)
        alert.addAction(inMemoryStorageAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchDrinks() {
        presenter?.fetchDrinks()
    }
    
    func downloadImage(from url: String) {
        guard let newURL = URL(string: url) else {
            return
        }
        
        presenter?.downloadImage(from: newURL)
    }
    
    func showData(_ drinks: [FavoritesEntity]) {
        self.drinks = drinks
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
    
    func showImage(_ image: Data, from url: String) {
        if var results = drinks, let row = results.firstIndex(where: {$0.thumb == url}) {
            var drink = results[row]
            drink.image = image
            
            results[row] = drink
            drinks = results
            tableView.reloadData()
        }
    }
    
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = drinks?.count, count > 0 else {
            self.tableView.addBackgroundView(with: "No favorites recipes.")
            return 0
        }
        
        self.tableView.restore()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = drinks?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: DrinkTableViewCell.identifier) as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        
        if let data = drink.image {
            cell.drinkImage.image = UIImage(data: data)
        } else {
            self.downloadImage(from: drink.thumb)
        }
        
        cell.drinkLabel.text = drink.name
        cell.categoryLabel.text = drink.category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let drink = drinks?[indexPath.row] else {
            return
        }
        
        presenter?.showRecipe(for: drink.id, navigationController: self.navigationController!)
    }
}

extension FavoritesViewController {
    func setupAccessibility() {
        if UIAccessibility.isVoiceOverRunning {
            self.navigationItem.rightBarButtonItem?.accessibilityHint = "Double tap to select a different type of storage"
            self.navigationItem.rightBarButtonItem?.accessibilityLabel = "Select Storage"
            self.navigationItem.rightBarButtonItem?.accessibilityTraits = [.button]
        }
    }
}
