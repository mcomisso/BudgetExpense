//
//  BECategorySelector.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import Material
import Iconic


enum CategoryCollectionViewType: Int {
    case color = 1000
    case gliph = 1010
}

final class BECategorySelectorViewController: UIViewController {

    class GeneratedCategory {
        private var gliph: UIImage?
        private var color: UIColor = .lightGray

        func setColor(color: UIColor) {
            self.color = color
        }

        func setImage(image: UIImage) {
            self.gliph = image
        }

        func validate() -> Bool {
            if gliph == nil {
                return false
            }
            return true
        }

        func imageRepresentation() -> UIImage? {
            return self.gliph?.tint(with: self.color)
        }
    }

    var newCategory: GeneratedCategory = GeneratedCategory()

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var collectionViewColors: UICollectionView!

    let colorList: [UIColor] = [.white, .red, .green, .blue, .yellow, .purple, .cyan, .black, .orange]

    var gliphList: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0..<FontAwesomeIcon.count {
            let image = Iconic.standardDimension(icon: FontAwesomeIcon.init(rawValue: index)!)
            self.gliphList.append(image)
        }

        self.collectionView.delegate = self
        self.collectionView.tag = CategoryCollectionViewType.gliph.rawValue

        self.collectionViewColors.tag = CategoryCollectionViewType.color.rawValue

    }


    @IBAction func saveAction(_ sender: Any) {

        // Save currently selected into.. realm?

    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension BECategorySelectorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let colorType = CategoryCollectionViewType.init(rawValue: collectionView.tag) {
            switch colorType {
            case .color:
                // Selected color
                self.newCategory.setColor(color: self.colorList[indexPath.row])

            case .gliph:
                // Selected gliph
                self.newCategory.setImage(image: self.gliphList[indexPath.row])
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.contentView.backgroundColor = .clear
    }
}
