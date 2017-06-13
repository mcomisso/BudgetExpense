//
//  BECategoriesCollectionView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import RealmSwift
import Material

protocol BECategoriesCollectionViewControllerDelegate: class {
    func didSelectAddCategory()
}

class BECategoriesCollectionView: UICollectionViewController {

    weak var delegate: BECategoriesCollectionViewControllerDelegate?

    var dataSource: Results<CategoryModel>? = nil

    var type: BEAddDataType = .expense

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        let addCategoryButton = Button()
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setImage(Icon.addCircleOutline?.tint(with: .white), for: .normal)
        addCategoryButton.setTitle("Add Category", for: .normal)
        addCategoryButton.addTarget(self, action: #selector(self.didPressAddCategory), for: .touchUpInside)

        self.view.addSubview(addCategoryButton)

        NSLayoutConstraint.activate([addCategoryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     addCategoryButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])


        self.dataSource = BERealmManager.shared.getCategories()
    }

    func didPressAddCategory() {
        print("Add category!")

        self.delegate?.didSelectAddCategory()
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.dataSource?.count == 0 {
            self.collectionView?.isHidden = true
        }
    }

}

// MARK:- DataSource
extension BECategoriesCollectionView {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let ds = self.dataSource {
            return ds.count
        }
        return 0
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BEConstants.Identifiers.categoriesCellIdentifier, for: indexPath) as! BECategoryCollectionViewCell
        return cell
    }
}
