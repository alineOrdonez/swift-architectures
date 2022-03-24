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
    private var categories: [CategoryEntity]?
    private var shoudlAddTopConstraint: Bool = false
    
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
        tableView.rowHeight = 140
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    func fetchData() {
        presenter?.fetchCategories()
    }
    
    func showData(_ categories: [CategoryEntity]) {
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
        
        cell.setupUI(with: category, shouldAddTopConstraint: shoudlAddTopConstraint)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let category = categories?[indexPath.row] else {
            return
        }
        
        presenter?.showDrinks(for: category, navigationController: self.navigationController!)
    }
}

extension CategoryListViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
        configureView(for: traitCollection)
      }
    }
    
    private func configureView(for traitCollection: UITraitCollection) {
      let contentSize = traitCollection.preferredContentSizeCategory
      if contentSize.isAccessibilityCategory {
          tableView.rowHeight = 200
          shoudlAddTopConstraint = true
      } else {
          tableView.rowHeight = 150
          shoudlAddTopConstraint = false
      }
        tableView.reloadData()
    }
}
