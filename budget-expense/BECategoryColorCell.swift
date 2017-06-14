//
//  BECategoryColorCell.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

final class BEColorCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = self.frame.width / 2.0
        self.contentView.clipsToBounds = true
    }

    func setColor(_ color: UIColor) {
        self.contentView.backgroundColor = color
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.backgroundColor = .clear
    }
}
