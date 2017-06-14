//
//  BECategoriesCollectionView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import Material

protocol BECategoriesCollectionViewControllerDelegate: class {
    func didSelectAddCategory()
}

class BECategoriesCollectionView: UICollectionViewController {

    weak var delegate: BECategoriesCollectionViewControllerDelegate?

    var dataSource: [BECategoryProtocol] {
        get {
            return BERealmManager.shared.getCategories()
        }
    }

    var type: BEAddDataType = .expense

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        if self.dataSource.count == 0 {

            let addCategoryButton = Button()
            addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
            addCategoryButton.setImage(Icon.addCircleOutline?.tint(with: .white), for: .normal)
            addCategoryButton.setTitle("Add Category", for: .normal)
            addCategoryButton.addTarget(self, action: #selector(self.didPressAddCategory), for: .touchUpInside)
            self.view.addSubview(addCategoryButton)


        NSLayoutConstraint.activate([addCategoryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     addCategoryButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])

        }
    }

    func didPressAddCategory() {
        print("Add category!")

        self.delegate?.didSelectAddCategory()
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.dataSource.count == 0 {
            self.collectionView?.isHidden = true
        }
    }

}

// MARK:- DataSource
extension BECategoriesCollectionView {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BEConstants.Identifiers.categoriesCellIdentifier, for: indexPath) as! BECategoryCollectionViewCell
        cell.setModelCategory(self.dataSource[indexPath.row])
        return cell
    }
}
