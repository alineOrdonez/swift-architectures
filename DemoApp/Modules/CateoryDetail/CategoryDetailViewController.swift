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
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            collectionView.clipsToBounds = true
            collectionView.collectionViewLayout = layout
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.register(DrinkCollectionViewCell.self,
                                    forCellWithReuseIdentifier: DrinkCollectionViewCell.cellIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        fetchDrinksByCategory()
        NotificationCenter.default.addObserver(self, selector: #selector(contentSizeChanged), name: nil, object: UIScreen.main.traitCollection)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        self.title = categoryName
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
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
            collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
        }
    }
    
    @objc
    func contentSizeChanged() {
        collectionView.reloadData()
    }
    
}

extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCollectionViewCell.cellIdentifier, for: indexPath) as? DrinkCollectionViewCell, let drink = drinks?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.setup(drink: drink, delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let drink = drinks?[indexPath.row] else {
            return
        }
        
        presenter?.showRecipe(for: drink.id, navigationController: self.navigationController!)
    }
}

extension CategoryDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let currentContentSize = ContentSizeCategory(category: UIScreen.main.traitCollection.preferredContentSizeCategory)
        
        if currentContentSize.categorySizeNumber > 6 {
            return CGSize(width: collectionView.frame.width, height: 150)
        } else {
            return CGSize(width: (collectionView.frame.width / 2) - 20, height: 150)
        }
    }
}

extension CategoryDetailViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection?.preferredContentSizeCategory
                != traitCollection.preferredContentSizeCategory
        else { return }
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
