//
//  CategoryDetailViewController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class CategoryDetailViewController: UIViewController, CategoryDetailPresenterToViewProtocol {
    
    var presenter: CategoryDetailViewToPresenterProtocol?
    var drinks: [Drink]?
    var categoryName: String?
    var isFavorite: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        fetchDrinksByCategory()
    }
    
    
    func setupUI() {
        self.title = categoryName
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        tableView.register(UINib(nibName: DrinkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DrinkTableViewCell.identifier)
        
        // Favorite button
        updateBarButtonItem()
    }
    
    // MARK: - Add to favorites
    @IBAction func addToFavorites(_ sender: Any) {
        if isFavorite {
            //Remove
            presenter?.update(drink: <#T##Drink#>, addToFavorites: <#T##Bool#>)
        } else {
            // Add
        }
        isFavorite = !isFavorite
        updateBarButtonItem()
    }
    
    func updateBarButtonItem() {
        let image = isFavorite ? "heart" : "heart.fill"
        let item = UIBarButtonItem(image: UIImage(systemName: image)!, style: .plain, target: self, action: #selector(addToFavorites(_:)))
        self.navigationItem.rightBarButtonItem = item
    }
    
    // MARK: - Fetch Data
    func fetchDrinksByCategory() {
        guard let categoryName = categoryName else {
            return
        }
        presenter?.fetchDrinks(by: categoryName)
    }
    
    func downloadImage(from url: String) {
        guard let newURL = URL(string: url) else {
            return
        }
        
        presenter?.downloadImage(from: newURL)
    }
    
    func showData(_ drinks: [Drink]) {
        self.drinks = drinks
        tableView.reloadData()
    }
    
    func actionCompleted() {
        let message = isFavorite ? "Recipe was added to favorites." : "Recipe was removed from favorites."
        showAlert(message: message)
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
    
    func showImage(_ image: UIImage, from url: String) {
        if var results = drinks, let row = results.firstIndex(where: {$0.thumb == url}) {
            var drink = results[row]
            drink.image = image
            
            results[row] = drink
            drinks = results
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = drinks?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: DrinkTableViewCell.identifier) as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        
        if drink.image == nil {
            self.downloadImage(from: drink.thumb)
        } else {
            cell.drinkImage.image = drink.image
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
