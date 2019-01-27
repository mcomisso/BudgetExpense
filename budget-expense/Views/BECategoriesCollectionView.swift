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


    /// Triggered when a "+" button is pressed, to create a new category
    ///
    /// - Parameter categoriesCollectionViewController: The triggering categoriesViewController
    func didSelectAddCategory(_ categoriesCollectionViewController: BECategoriesCollectionView)


    /// Triggered when a category is tapped
    ///
    /// - Parameters:
    ///   - categoriesCollectionViewController: The triggering categoriesViewController
    ///   - category: The category selected
    func didSelectCategory(_ categoriesCollectionViewController: BECategoriesCollectionView, category: BECategory)
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

    @objc func didPressAddCategory() {
        print("Add category!")

        self.delegate?.didSelectAddCategory(self)
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

        if section == 0 {
            return self.dataSource.count

        }

        return 1
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.categoriesCellIdentifier, for: indexPath) else { fatalError() }

        if indexPath.section == 0 {
            cell.setModelCategory(self.dataSource[indexPath.row])
            cell.setNeedsLayout()
            cell.layoutSubviews()
        } else {
            cell.setModelCategory(BECategory.init(gliph: "plus_sign", color: .white, name: "plus_sign"))
        }
        return cell
    }
}

extension BECategoriesCollectionView {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // Add
            self.delegate?.didSelectAddCategory(self)
        } else if indexPath.section == 0 {
            self.delegate?.didSelectCategory(self, category: self.dataSource[indexPath.row] as! BECategory)
        }
    }
}
