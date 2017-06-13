//
//  BETransationCell.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import Material

enum CellButtonActionType: Int {
    case share = 101
    case options = 202
}

class BECollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var card: Card!

    var amount: Amount?

    lazy var amountLabel: UILabel! = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 40)

        return l
    }()

    func prepareCard(amount: Amount) {

        self.amount = amount

        guard let actualAmount = self.amount else { return }

        amountLabel.text = NSNumber(value: actualAmount.amount).toCurrency()
        amountLabel.textColor = actualAmount.isExpense ? BETheme.Colors.accent : BETheme.Colors.primary

        let verticalIconButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)
        verticalIconButton.tag = CellButtonActionType.options.rawValue
        verticalIconButton.addTarget(self, action: #selector(didSelectButton(_:)), for: .touchUpInside)

        let toolbar = Toolbar(rightViews: [verticalIconButton])
        toolbar.detail = actualAmount.isExpense ? "Expense" : "Income"
        toolbar.detailLabel.textAlignment = .left
        toolbar.title = actualAmount.category?.name ?? "Test"
        toolbar.titleLabel.textAlignment = .left

        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.text = BEUtils().dateFormatter.string(from: amount.date)

        let shareButton = IconButton(image: Icon.share, tintColor: Color.blueGrey.base)
        shareButton.tag = CellButtonActionType.share.rawValue
        shareButton.addTarget(self, action: #selector(didSelectButton(_:)), for: .touchUpInside)

        let notesText = UILabel()
        notesText.font = RobotoFont.regular(with: 12)
        notesText.text = self.amount?.notes

        let bottomBar = Bar(leftViews: [dateLabel], rightViews: [shareButton], centerViews: [notesText])

        card.toolbar = toolbar
        card.contentView = amountLabel
        card.bottomBar = bottomBar
    }

    func didSelectButton(_ sender: Any) {
        guard let button = sender as? Button,
            let action = CellButtonActionType.init(rawValue: button.tag) else { return }

        switch action {
        case .options:
            // Vertical button
            print("Pressed options")
        case .share:
            // Share button
            print("Pressed share")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.amountLabel.text = nil
        self.amount = nil
    }
}
