//
//  CategoryDetailViewController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class CategoryDetailViewController: UIViewController, CategoryDetailPresenterToViewProtocol {
    
    var presenter: CategoryDetailViewToPresenterProtocol?
    var drinks: [CategoryDetailEntity]?
    var categoryName: String?
    
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
    
    func showData(_ drinks: [CategoryDetailEntity]) {
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
        
        if let data = drink.image {
            cell.drinkImage.image = UIImage(data: data)
        } else {
            self.downloadImage(from: drink.thumb)
        }
        
        cell.drinkLabel.text = drink.name
        
        if let category = drink.category  {
            cell.categoryLabel.isHidden = false
            cell.categoryLabel.text = category
        } else {
            cell.categoryLabel.isHidden = true
        }
        
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
