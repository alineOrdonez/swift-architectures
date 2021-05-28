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
    
    func showData(_ drinks: [Drink]) {
        self.drinks = drinks
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = drinks?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell") as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(with: drink)
        return cell
    }
}
