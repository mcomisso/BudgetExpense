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
    let amounts: Results<Amount>

    init(date: Date) {
        self.date = date
        self.amounts = BERealmManager.shared.getDataForDay(day: self.date)
    }
}

final class BETransactionsHistoryCollectionViewController: UICollectionViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!

    let notificationManager = BENotificationCenterManager()

    var realmNotificationsTokens: [NotificationToken] = []

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


    deinit {
        for token in self.realmNotificationsTokens {
            token.stop()
        }
    }

    fileprivate func reloadTransactions(shouldReloadCollectionView: Bool = false) {
        self.transactionsData = BERealmManager.shared.getAvailableDays().map { BETransactions(date: $0) }
        for (index, collection) in self.transactionsData.enumerated() {
            let token = collection.amounts.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Amount>>) in
                guard let strongSelf = self else { return }

                switch changes {

                case .error(let error):
                    print(error.localizedDescription)

                case .initial(let t):
                    print("Initial")
                    print(t.description)

                case .update(_, let deletions, let insertions, _):
                    // Find cell and delete it

                    DispatchQueue.main.async {

                        self?.collectionView?.performBatchUpdates({
                            strongSelf.collectionView?.insertItems(at: insertions.map { IndexPath(item: $0, section: index)})

                            strongSelf.collectionView?.deleteItems(at: deletions.map { IndexPath(item: $0, section: index) })

                        }, completion: { (completed) in
                            print(completed.description)
                        })
                    }
                }
            })
            self.realmNotificationsTokens.append(token)
        }

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.overviewCellIdentifier, for: indexPath)!

        let amountObject = self.transactionsData[indexPath.section].amounts[indexPath.row]

        cell.prepareCard(amount: amountObject)
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.bEHeaderViewReuseIdentifier, for: indexPath)!

        reusableView.setDay(date: self.transactionsData[indexPath.section].date, transactions: self.transactionsData[indexPath.section].amounts)

        return reusableView
    }
}

extension BETransactionsHistoryCollectionViewController: BETransactionCellDelegate {

    func didPressOption(cell: BETransactionCollectionViewCell, amount: Amount?) {
        // Options to manage

        let alertSheet = UIAlertController(title: "What to do?", message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            // Delete from realm
            guard let amount = amount else { return }

            BERealmManager.shared.delete(amount: amount, completion: { (success) in
                if success {
                    if BESettings.appSoundsEnabled.boolValue {
                        BESoundPlayer.play(sound: .beepOff)
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
        guard let amount = amount else { return }
        let activityVC = UIActivityViewController.init(activityItems: [amount.description], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
}
