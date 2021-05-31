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
    let imageCache = NSCache<AnyObject, AnyObject>()
    
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
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(UINib(nibName: DrinkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DrinkTableViewCell.identifier)
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
    
    func downloadImage(from url: String) {
        guard let newURL = URL(string: url) else {
            return
        }
        
        presenter?.downloadImage(from: newURL)
    }
    
    func showData(_ drinks: [Drink]) {
        searchResults = drinks
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
    
    func showImage(_ image: UIImage, from url: String) {
        if var results = searchResults, let row = results.firstIndex(where: {$0.thumb == url}) {
            var drink = results[row]
            drink.image = image
            
            results[row] = drink
            searchResults = results
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = searchResults?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: DrinkTableViewCell.identifier) as? DrinkTableViewCell else {
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
        
        guard let drink = searchResults?[indexPath.row] else {
            return
        }
        
        presenter?.showRecipe(for: drink.id, navigationController: self.navigationController!)
        
    }
}
