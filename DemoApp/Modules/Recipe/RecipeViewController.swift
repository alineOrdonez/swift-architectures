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
    var drink: Drink?
    
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
    }
    
    func setupUI() {
        nameLabel.text = drink?.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.reloadData()
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
    
    func getData() {
        presenter?.getRecipe(with: recipeId)
    }
    
    func downloadImage(drink: Drink) {
        if let url = URL(string: drink.thumb) {
            presenter?.downloadImage(from: url)
        }
    }
    
    func showRecipe(_ recipe: Drink) {
        
        if let url = recipe.video, let youTubeID = url.youtubeID {
            isVideoAvailable = true
            loadYoutube(videoID: youTubeID)
        } else {
            downloadImage(drink: recipe)
        }
       
        self.drink = recipe
        setupUI()
    }
    
    func showError(_ message: String) {
        showAlert(message: message)
    }
    
    func showImage(_ image: UIImage) {
        self.imageView.image = image
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return drink?.listOfIngredients?.count ?? 0
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
            let dictionary = drink.listOfIngredients?[indexPath.row]
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "RecipeTableViewCell")
            cell.textLabel?.text = dictionary?.keys.first
            cell.detailTextLabel?.text = dictionary?.values.first
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "RecipeTableViewCell")
            cell.textLabel?.text = drink.glass
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "RecipeTableViewCell")
            cell.textLabel?.text = drink.instructions
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    
}
