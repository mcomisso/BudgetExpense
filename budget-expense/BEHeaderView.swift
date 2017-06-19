//
//  BEHeaderView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import RealmSwift

final class BEHeaderView: UICollectionReusableView {

    @IBOutlet weak var dateHeader: UILabel!
    @IBOutlet weak var dateSubHeader: UILabel!

    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var totalIncome: UILabel!

    static let reuseIdentifier = "BEHeaderViewReuseIdentifier"

    var transactions: Results<Amount>!
    private var notificationsTokens: [NotificationToken] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        self.totalIncome.textColor = BETheme.Colors.income
        self.totalExpenses.textColor = BETheme.Colors.expense
    }

    var day: Date? {
        didSet {
            guard let day = self.day else { return }
            self.dateHeader.text    = BEUtils.longDateFormatter.string(from: day)
            self.dateSubHeader.text = BEUtils.dayNameFormatter.string(from: day)

            self.calculateTotalAmounts()
        }
    }

    private func calculateTotalAmounts() {
        var expenses: Double = 0
        var incomes: Double = 0
        for t in transactions {
            if t.isExpense {
                expenses += t.amount
            } else {
                incomes += t.amount
            }
        }


        self.totalIncome.text = "\(NSNumber(floatLiteral: incomes).toCurrency())"
        self.totalExpenses.text = "\(NSNumber(floatLiteral: expenses).toCurrency())"

    }

    func setDay(date: Date, transactions: Results<Amount>) {
        self.transactions = transactions
        self.day = date

        let token = self.transactions.addNotificationBlock { [weak self] (changes: RealmCollectionChange<Results<Amount>>) in
            switch changes {
            case .error(let error):
                print("Error " + error.localizedDescription)

            case .initial:
                print("Initial")

            case.update(_, _, _, _):
                print("Changes detected")
                self?.calculateTotalAmounts()

            }
        }

        self.notificationsTokens.append(token)
    }

    deinit {
        for token in self.notificationsTokens {
            token.stop()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.totalIncome.text = nil
        self.totalExpenses.text = nil


        for token in self.notificationsTokens {
            token.stop()
        }

        self.day = nil
        self.dateHeader.text = nil
        self.dateSubHeader.text = nil
    }
}
