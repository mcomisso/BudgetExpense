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
import Iconic

enum CellButtonActionType: Int {
    case share = 101
    case options = 202
}

protocol BETransactionCellDelegate: class {
    func didPressOption(cell: BETransactionCollectionViewCell, amount: Amount?)
    func didPressShare(cell: BETransactionCollectionViewCell, amount: Amount?)
}

class BETransactionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var card: Card!

    weak var delegate: BETransactionCellDelegate?

    var amount: Amount?

    lazy var amountLabel: UILabel! = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 40)

        return l
    }()

    var gradiendLayer: CAGradientLayer? = nil

    func prepareCard(amount: Amount) {

        self.amount = amount

        guard let actualAmount = self.amount else { return }

        amountLabel.text = NSNumber(value: actualAmount.amount).toCurrency()
        amountLabel.textColor = .white

        let verticalIconButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)
        verticalIconButton.tag = CellButtonActionType.options.rawValue
        verticalIconButton.addTarget(self, action: #selector(didSelectButton(_:)), for: .touchUpInside)




        let toolbar = Toolbar(leftViews: [UIImageView.init(image: Iconic.standardDimension(icon: .planeIcon, size: CGSize.init(width: 15, height: 15), color: .white))])
//        Toolbar(rightViews: [verticalIconButton])
//        toolbar.detail = actualAmount.isExpense ? "Expense" : "Income"
//        toolbar.detailLabel.textAlignment = .left
//        toolbar.title = actualAmount.category?.name ?? "Test"
//        toolbar.titleLabel.textAlignment = .left

        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.text = BEUtils.dateFormatter.string(from: amount.date)

        let shareButton = IconButton(image: Icon.share, tintColor: Color.blueGrey.base)
        shareButton.tag = CellButtonActionType.share.rawValue
        shareButton.addTarget(self, action: #selector(didSelectButton(_:)), for: .touchUpInside)

        let notesText = UILabel()
        notesText.font = RobotoFont.regular(with: 12)
        notesText.text = self.amount?.notes

        let bottomBar = Bar(leftViews: [dateLabel], rightViews: [shareButton, verticalIconButton], centerViews: [notesText])

        card.toolbar = toolbar
        card.contentView = amountLabel

        if amount.isExpense {
            card.container.gradientFromColor(BETheme.Colors.expense)
        } else {
            card.container.gradientFromColor(BETheme.Colors.income)
        }

        card.bottomBar = bottomBar

        card.toolbar?.backgroundColor = .clear
        card.contentView?.backgroundColor = .clear
        card.bottomBar?.backgroundColor = .clear
    }

    func didSelectButton(_ sender: Any) {
        guard let button = sender as? Button,
            let action = CellButtonActionType.init(rawValue: button.tag) else { return }

        switch action {
        case .options:
            // Vertical button
            print("Pressed options")
            self.delegate?.didPressOption(cell: self, amount: self.amount)

        case .share:
            // Share button
            print("Pressed share")
            self.delegate?.didPressShare(cell: self, amount: self.amount)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.gradiendLayer = nil
        self.amountLabel.text = nil
        self.amount = nil
    }
}
