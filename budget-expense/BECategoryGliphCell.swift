//
//  BECategoryGliphCell.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

protocol BEGliphCellDelegate: class {
    func didSelectGliph(cell: BEGliphCell)
}

final class BEGliphCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setImage(image: UIImage?) {
        self.imageView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
