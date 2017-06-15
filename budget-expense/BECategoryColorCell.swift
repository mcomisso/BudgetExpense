//
//  BECategoryColorCell.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

protocol BEColorCellDelegate: class {
    func didSelectColor(cell: BEColorCell)
}

final class BEColorCell: UICollectionViewCell {

    private var gradientLayer: CAGradientLayer? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.backgroundColor = .clear

        self.contentView.layer.cornerRadius = self.frame.width / 2.0
        self.contentView.clipsToBounds = true
    }

    func setColor(_ color: UIColor) {
        self.gradientLayer = self.contentView.gradientFromColor(color)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.gradientLayer?.removeFromSuperlayer()
    }
}
