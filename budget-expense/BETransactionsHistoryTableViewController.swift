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
import PKHUD

class BETransactionsHistoryCollectionViewController: UICollectionViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!

    var transactions: [Amount] {
        get {
            return Array(BERealmManager.shared.getWeekDataForTableView())
        }
    }

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

        self.collectionView?.isPrefetchingEnabled = false
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
        return self.transactions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BEConstants.Identifiers.overviewCellIdentifier, for: indexPath) as! BETransactionCollectionViewCell

        let amountObject = self.transactions[indexPath.row]

        cell.prepareCard(amount: amountObject)
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BEHeaderView.reuseIdentifier, for: indexPath) as! BEHeaderView

        reusableView.setDay(date: Date())

        return reusableView
    }
}

extension BETransactionsHistoryCollectionViewController: BETransactionCellDelegate {

    func didPressOption(cell: BETransactionCollectionViewCell, amount: Amount?) {
        // Options to manage

        let alertSheet = UIAlertController(title: "What to do?", message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (alert) in
            // Delete from realm
            guard let amount = amount else { return }
            BERealmManager.shared.delete(amount: amount, completion: { (success) in
                if success {
                    BESoundPlayer.play(sound: .beepOff)
                    self?.collectionView?.reloadData()
                    self?.collectionView?.collectionViewLayout.invalidateLayout()

                } else {
                    // Display error
                    HUD.flash(.error)
                }
            })

        }))

        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alertSheet, animated: true, completion: nil)
    }

    func didPressShare(cell: BETransactionCollectionViewCell, amount: Amount?) {
        // Options to share cell content



    }
    
}
