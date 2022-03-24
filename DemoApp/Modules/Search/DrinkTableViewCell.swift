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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        drinkImage.contentMode = .scaleAspectFit
        drinkImage.image = UIImage(named: "default_drink")
        
        setupAccessibility()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupAccessibility() {
        accessibilityHint = "Double tap for more detail"
        drinkLabel.font = UIFont.preferredFont(for: .title3, weight: .bold)
        drinkLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        categoryLabel.adjustsFontForContentSizeCategory = true
    }
}
