//
//  BECategoriesCollectionViewCell.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit

class BECategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.frame.width / 2.0
    }

    func setModelCategory(_ category: BECategoryProtocol) {
        self.icon.image = category.generateImageFromIcon().tint(with: category.color)
//        self.contentView.gradientFromColor(category.color)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.icon.image = nil
    }
}
