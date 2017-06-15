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


fileprivate struct BETransactions {
    let date: Date
    let amounts: [Amount]

    init(date: Date) {
        self.date = date
        self.amounts = BERealmManager.shared.getDataForDay(day: self.date)
    }
}

final class BETransactionsHistoryCollectionViewController: UICollectionViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!

    lazy var skeleton: UIStackView = {

        let imageView = UIImageView(image: #imageLiteral(resourceName: "add").tint(with: Color.grey.lighten2))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let description = UILabel()
        description.textAlignment = .center
        description.numberOfLines = 0
        description.text = "No data available!\nYou can add data by swiping up or down in the previous screen."
        description.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [imageView, description])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .vertical

        return stack
    }()

    fileprivate var transactionsData: [BETransactions] = [] {
        didSet {
            if transactionsData.count == 0 {
                // Display "No data available" message
                self.skeleton.isHidden = false
            } else {
                self.skeleton.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Transactions"

        self.view.addSubview(self.skeleton)
        NSLayoutConstraint.activate([self.skeleton.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                                     self.skeleton.heightAnchor.constraint(equalTo: self.skeleton.widthAnchor),
                                     self.skeleton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.skeleton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])

        self.closeButton.title = ""
        self.closeButton.image = Icon.close

        if let collectionLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionLayout.estimatedItemSize = CGSize(width: self.view.frame.size.width, height: 160)

            collectionLayout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 76)
            collectionLayout.sectionHeadersPinToVisibleBounds = true
        }

        self.collectionView?.isPrefetchingEnabled = false

        self.reloadTransactions(shouldReloadCollectionView: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeView(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    fileprivate func reloadTransactions(shouldReloadCollectionView: Bool = false) {
        self.transactionsData = BERealmManager.shared.getAvailableDays().map { BETransactions(date: $0) }
        if shouldReloadCollectionView {
            self.collectionView?.reloadData()
        }
    }

}
    // MARK: - Table view data source
extension BETransactionsHistoryCollectionViewController {


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.transactionsData.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.transactionsData[section].amounts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BEConstants.Identifiers.overviewCellIdentifier, for: indexPath) as! BETransactionCollectionViewCell

        let amountObject = self.transactionsData[indexPath.section].amounts[indexPath.row]

        cell.prepareCard(amount: amountObject)
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BEHeaderView.reuseIdentifier, for: indexPath) as! BEHeaderView

        reusableView.setDay(date: self.transactionsData[indexPath.section].date, transactions: self.transactionsData[indexPath.section].amounts)

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
//                    self?.collectionView?.collectionViewLayout.invalidateLayout()

                    guard let `self` = self else { return }

                    // Find cell and delete it
                    if let indexPath = self.collectionView?.indexPath(for: cell) {

                        let preCount = self.transactionsData.count
                        self.reloadTransactions()

                        // Delete section if the dataSource has less values
                        if self.transactionsData.count < preCount {
                            self.collectionView?.performBatchUpdates({ 
                                self.collectionView?.deleteSections(IndexSet(integer: indexPath.section))
                                self.collectionView?.deleteItems(at: [indexPath])
                            }, completion: { (completed) in
                                if completed {
                                    HUD.flash(.success)
                                }
                            })

                        } else {
                            self.collectionView?.deleteItems(at: [indexPath])
                        }
                    }

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
