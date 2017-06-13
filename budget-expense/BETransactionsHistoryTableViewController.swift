//
//  BESettingsTableViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import RealmSwift
import Material

class BETransactionsHistoryCollectionViewController: UICollectionViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Transactions"

        self.closeButton.title = ""
        self.closeButton.image = Icon.close

        if let collectionLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionLayout.estimatedItemSize = CGSize(width: self.view.frame.size.width, height: 160)

            collectionLayout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 76)
            collectionLayout.sectionHeadersPinToVisibleBounds = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeView(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}
    // MARK: - Table view data source
extension BETransactionsHistoryCollectionViewController {


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BERealmManager.shared.getWeekDataForTableView().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BEConstants.Identifiers.overviewCellIdentifier, for: indexPath) as! BECollectionViewCell

        let amountObject = BERealmManager.shared.getWeekDataForTableView()[indexPath.row]

        cell.prepareCard(amount: amountObject)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BEHeaderView.reuseIdentifier, for: indexPath) as! BEHeaderView

        reusableView.setDay(date: Date())

        return reusableView
    }
}
