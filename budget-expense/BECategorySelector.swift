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

    final class GeneratedCategory {
        private var gliph: String?
        private var color: UIColor = .lightGray

        func setColor(color: UIColor) {
            self.color = color
        }

        func setGliph(iconName: String) {
            self.gliph = iconName
        }

        func validate() -> Bool {
            if gliph == nil {
                return false
            }
            return true
        }

        func toCategoryObject() -> BECategory? {
            if self.validate() {
                return BECategory.init(gliph: self.gliph!, color: self.color, name: self.gliph!)
            }
            return nil
        }
    }

    var newCategory: GeneratedCategory = GeneratedCategory()

    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var collectionViewColors: UICollectionView!

    let colorList: [UIColor] = [Color.amber.lighten2, Color.amber.darken1, Color.blue.lighten2, Color.blue.darken2, Color.brown.lighten2, Color.brown.darken2, Color.cyan.lighten2, Color.cyan.darken2, Color.deepOrange.lighten2, Color.deepOrange.darken2, Color.deepPurple.lighten2, Color.deepPurple.darken2, Color.green.lighten2, Color.green.darken2, Color.indigo.lighten2, Color.indigo.darken2, Color.lightBlue.lighten2, Color.lightBlue.darken2, Color.lime.lighten2, Color.lime.darken2, Color.pink.lighten2, Color.pink.darken2, Color.purple.lighten2, Color.purple.darken2, Color.red.lighten2, Color.red.darken2, Color.teal.lighten2, Color.teal.darken2, Color.yellow.lighten2, Color.yellow.darken2]

    var gliphList: [FontAwesomeIcon] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0..<FontAwesomeIcon.count {
            let image = FontAwesomeIcon(rawValue: index)!
            self.gliphList.append(image)
        }

        self.collectionView.delegate = self
        self.collectionView.tag = CategoryCollectionViewType.gliph.rawValue

        self.collectionViewColors.tag = CategoryCollectionViewType.color.rawValue

    }


    @IBAction func saveAction(_ sender: Any) {

        if let category = self.newCategory.toCategoryObject() {

            BERealmManager.shared.saveCategory(category)
            self.dismiss(animated: true, completion: nil)
        }
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
                let gliphList = self.gliphList[indexPath.row]
                cell.setImage(image: Iconic.defaultDimension(icon: gliphList))
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
                self.newCategory.setGliph(iconName: self.gliphList[indexPath.row].name)
                
            }
        }
    }
}
