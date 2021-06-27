//
//  RecipeViewController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 30/05/21.
//

import Foundation
import UIKit
import WebKit
import AVKit

class RecipeViewController: UIViewController, WKNavigationDelegate, RecipePresenterToViewProtocol {
    
    var presenter: RecipeViewToPresenterProtocol?
    var recipeId: String = ""
    var drink: RecipeEntity?
    
    private let loadingView = LoadingViewController()
    private lazy var isFavoriteDrink: Bool = false {
        didSet {
            updateBarButton()
        }
    }
    private var webView: WKWebView!
    private var isVideoAvailable: Bool = false {
        didSet {
            imageView.isHidden = isVideoAvailable
            videoView.isHidden = !isVideoAvailable
            videoView.contentMode = .scaleAspectFill
            multimediaStackView.alignment = .fill
            multimediaStackView.distribution = .fillProportionally
        }
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var multimediaStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        isFavoriteRecipe()
    }
    
    func setupUI() {
        nameLabel.text = drink?.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        tableView.reloadData()
    }
    
    func startAnimating() {
        addChild(loadingView)
        loadingView.view.frame = view.frame
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
    }
    
    func stopAnimating() {
        loadingView.willMove(toParent: nil)
        loadingView.view.removeFromSuperview()
        loadingView.removeFromParent()
    }
    
    // MARK: - Add Recipe to Favorites
    @IBAction func addToFavorites(_ sender: Any) {
        isFavoriteDrink = !isFavoriteDrink
        presenter?.addRemove(drink: drink!, isFavorite: isFavoriteDrink)
    }
    
    func isFavoriteRecipe() {
        presenter?.isFavorite(drink: recipeId)
    }
    
    //MARK:- Play Video
    func loadYoutube(videoID:String) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
            return
        }
        let frame = CGRect(x: 0, y: 0, width: multimediaStackView.frame.width, height: videoView.frame.height)
        webView = WKWebView(frame: frame)
        videoView.addSubview(webView)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: youtubeURL))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func updateBarButton() {
        if isFavoriteDrink {
            let item = UIBarButtonItem(image: UIImage(systemName: "heart.fill")!, style: .plain, target: self, action: #selector(addToFavorites(_:)))
            self.navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: UIImage(systemName: "heart")!, style: .plain, target: self, action: #selector(addToFavorites(_:)))
            self.navigationItem.rightBarButtonItem = item
        }
    }
    
    func getData() {
        startAnimating()
        presenter?.getRecipe(with: recipeId)
    }
    
    func downloadImage(drink: RecipeEntity) {
        if let url = URL(string: drink.thumb) {
            presenter?.downloadImage(from: url)
        }
    }
    
    func showRecipe(_ recipe: RecipeEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.stopAnimating()
            
            if let url = recipe.video, let youTubeID = url.youtubeID {
                self?.isVideoAvailable = true
                self?.loadYoutube(videoID: youTubeID)
            } else {
                self?.downloadImage(drink: recipe)
            }
            
            self?.drink = recipe
            self?.setupUI()
        }
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
    
    func showImage(_ image: Data) {
        self.imageView.image = UIImage(data: image)
    }
    
    func foundFavoriteRecipe(isFavorite: Bool) {
        self.isFavoriteDrink = isFavorite
    }
    
    func didCompleteAction() {
        let message = isFavoriteDrink ? "Drink was added to Favorites!" : "Drink was removed from Favorites!"
        showAlert(message: message)
    }
}
extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return drink?.ingredients.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ingredients:"
        case 1:
            return "Glass"
        default:
            return "Instructions"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = self.drink else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let dictionary = drink.ingredients[indexPath.row]
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "RecipeTableViewCell")
            cell.textLabel?.text = dictionary.keys.first
            cell.detailTextLabel?.text = dictionary.values.first
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "RecipeTableViewCell")
            cell.textLabel?.text = drink.glass
            cell.selectionStyle = .none
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "RecipeTableViewCell")
            cell.textLabel?.text = drink.instructions
            cell.textLabel?.textAlignment = .justified
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
}
