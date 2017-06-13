//
//  BECategorySelector.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import Material

final class BEColorCell: UICollectionViewCell {
    func setColor(_ color: UIColor) {
        self.contentView.backgroundColor = color
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.backgroundColor = .clear
    }
}

final class BEGliphCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func setImage(image: UIImage?) {
        self.imageView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}

enum CategoryCollectionViewType: Int {
    case color = 1000
    case gliph = 1010
}

final class BECategorySelectorViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var collectionViewColors: UICollectionView!


    let colorList: [UIColor] = [.white, .red, .green, .blue, .yellow, .purple, .cyan, .black, .orange]

    let gliphList: [UIImage?] = [Icon.add, Icon.addCircle, Icon.addCircleOutline, Icon.arrowBack, Icon.arrowDownward]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.tag = CategoryCollectionViewType.gliph.rawValue

        self.collectionViewColors.tag = CategoryCollectionViewType.color.rawValue

    }

}

extension BECategorySelectorViewController: UICollectionViewDataSource {


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let colorType = CategoryCollectionViewType.init(rawValue: collectionView.tag) {

            switch colorType {
            case .color:
                return self.colorList.count
            case .gliph:
                return self.gliphList.count
            }
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let colorType = CategoryCollectionViewType.init(rawValue: collectionView.tag) {

            switch colorType {
            case .color:

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.colorReuseIdentifier, for: indexPath)!

                cell.setColor(self.colorList[indexPath.row])

                return cell

            case .gliph:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.gliphReuseIdentifier, for: indexPath)!

                cell.setImage(image: self.gliphList[indexPath.row])
                return cell
            }
        }

        fatalError()
    }

}
