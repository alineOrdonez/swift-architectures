//
//  SearchViewController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class SearchViewController: UIViewController, SearchPresenterToViewProtocol, UISearchResultsUpdating, UISearchBarDelegate  {
    
    var presenter: SearchViewToPresenterProtocol?
    var searchController = UISearchController(searchResultsController: nil)
    var searchResults: [Drink]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    func setupUI() {
        self.title = "Search Drink"
        // Search Bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find a recipe"
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
    }
    
    // MARK: - Search Controller
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else {
            return
        }
        fetchRecipes(with: text)
    }
    
    // MARK: - Fetch Data
    func fetchRecipes(with name: String) {
        presenter?.searchRecipe(by: name)
    }
    
    func showData(_ drinks: [Drink]) {
        searchResults = drinks
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = searchResults?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell") as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(with: drink)
        return cell
    }
}
