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

class BECategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = ""
        self.icon.image = nil
    }
}

class BECategoriesCollectionView: UICollectionViewController {

    var dataSource: Results<CategoryModel>? = nil

    var type: BEAddDataType = .expense

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        self.dataSource = BERealmManager.shared.getCategories()
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
