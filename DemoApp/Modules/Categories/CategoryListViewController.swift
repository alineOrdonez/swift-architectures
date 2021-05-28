//
//  CategoryListViewController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import Foundation
import UIKit

class CategoryListViewController: UIViewController, CategoryListPresenterToViewProtocol {
    
    var presenter: CategoryListViewToPresenterProtocol?
    private var categories: [Category]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.fetchData()
    }
    
    func setupUI() {
        self.title = "Categories"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
    }
    
    func fetchData() {
        presenter?.fetchCategories()
    }
    
    func showData(_ categories: [Category]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
}

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = categories?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupUI(with: category)
        return cell
    }
    
    
}
