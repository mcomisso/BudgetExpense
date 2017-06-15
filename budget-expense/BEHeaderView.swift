//
//  BEHeaderView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

class BEHeaderView: UICollectionReusableView {

    @IBOutlet weak var dateHeader: UILabel!
    @IBOutlet weak var dateSubHeader: UILabel!

    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var totalIncome: UILabel!

    static let reuseIdentifier = "BEHeaderViewReuseIdentifier"

    var transactions: [Amount] = []

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
    }

    func setDay(date: Date, transactions: [Amount]) {
        self.transactions = transactions
        self.day = date
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        self.totalIncome.text = nil
        self.totalExpenses.text = nil

        self.day = nil
        self.dateHeader.text = nil
        self.dateSubHeader.text = nil
    }
}
