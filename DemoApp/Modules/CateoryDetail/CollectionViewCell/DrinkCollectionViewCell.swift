//
//  DrinkCollectionViewCell.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 08/03/22.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "DrinkCollectionViewCell"
    
    weak var delegate: CategoryDetailViewController?
    
    lazy var primaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var drinkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "default_drink")
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    private var currentContentSize: ContentSizeCategory {
        return ContentSizeCategory(category: UIScreen.main.traitCollection.preferredContentSizeCategory)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(drink: CategoryDetailEntity, delegate: CategoryDetailViewController) {
        self.delegate = delegate
        
        if let data = drink.image {
            drinkImageView.image = UIImage(data: data)
        } else {
            self.delegate?.downloadImage(from: drink.thumb)
        }
        
        if let category = drink.category  {
            secondaryLabel.isHidden = false
            secondaryLabel.text = category
        } else {
            secondaryLabel.isHidden = true
        }
        
        primaryLabel.text = drink.name
        
        addImageView()
        addLabelStackView()
    }
    
    private func addImageView() {
        contentView.addSubview(drinkImageView)
        
        drinkImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        drinkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        drinkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        let value = currentContentSize.categorySizeNumber > 6 ? 3.0 : 2.0
        let widthConstraint = drinkImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width / value)
        widthConstraint.isActive = true
        widthConstraint.priority = UILayoutPriority(999.0)
    }
    
    private func addLabelStackView() {
        labelStackView.addArrangedSubview(primaryLabel)
        labelStackView.addArrangedSubview(secondaryLabel)
        contentView.addSubview(labelStackView)
        labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: drinkImageView.leadingAnchor).isActive = true
    }
}

