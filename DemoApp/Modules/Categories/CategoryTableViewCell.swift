//
//  CategoryTableViewCell.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 28/05/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryImage.addBlur()
        categoryImage.layer.cornerRadius = 20
        categoryImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupAccessibility()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(with category: CategoryEntity, shouldAddTopConstraint: Bool = false) {
        categoryLabel.text = category.name
        let name = category.name.formatName()
        categoryImage.image = UIImage(named: name)
        
        if shouldAddTopConstraint {
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 2).isActive = true
        }
    }
    
    func setupAccessibility() {
        accessibilityHint = "Double tap to see drinks for this category"
        categoryLabel.font = UIFont.preferredFont(for: .subheadline, weight: .bold)
        categoryLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.numberOfLines = 0
    }
}
