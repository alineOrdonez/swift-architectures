//
//  DrinkTableViewCell.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var drinkImage: UIImageView!
    
    private var drink: Drink?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(with drink: Drink) {
        self.drink = drink
        drinkLabel.text = drink.name
        categoryLabel.text = drink.category
        drinkImage.contentMode = .scaleAspectFit
        if self.drink?.image == nil {
            downloadImage(from: drink.thumb)
        }
    }
    
    func downloadImage(from url: String) {
        guard let newURL = URL(string: url) else {
            return
        }
        getData(from: newURL) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.drinkImage.image = UIImage(data: data)
                self?.drink?.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
