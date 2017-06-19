//
//  CardContainer.swift
//  budget-expense
//
//  Created by Matteo Comisso on 19/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import Material
import Iconic

final class BECardDisplay: Card {

    required init?(coder aDecoder: NSCoder) {

        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 80)
        label.sizeToFit()
        label.text = NSNumber.init(value: 0.00).toCurrency()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1

        self.digits = label

        super.init(coder: aDecoder)
    }

    // Logic

    fileprivate var numericMem = NumericMem() {
        didSet {
            self.digits.text = self.numericMem.toNumber().toCurrency()
        }
    }

    // UI Elements
    public var type: BEAddDataType = .expense {
        didSet {
            if type == .income {
                self.digits.textColor = BETheme.Colors.income
            } else {
                self.digits.textColor = BETheme.Colors.expense
            }
        }
    }

    // TOP
    private let topBar = Toolbar()
    private lazy var categoryLogo: UIImageView = {
        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MIDDLE

    private var digits: UILabel

    // BOTTOM
    private let customBottomBar = Bar()
    private var dateLabel: UILabel {
        let l = UILabel()
        l.textColor = .black
        l.textAlignment = .center
        l.minimumScaleFactor = 0.5
        l.numberOfLines = 1
        return l
    }

    // GENERIC vars
    var category: BECategory? {
        didSet {
            guard let icon = self.category?.icon,
                let color = self.category?.color else {
                    return
            }

            self.categoryLogo.image = Iconic.defaultDimension(icon: FontAwesomeIcon(named: icon), color: color)

        }
    }

    func addDigit(digit: String) {
        self.numericMem.addDigit(digit: digit)
//        self.digits.text = self.numericMem.toNumber().toCurrency()
    }


    func deleteDigit() {
        self.numericMem.removeDigit()
    }

    func getAmount() -> Double {
        return self.numericMem.toDouble()
    }

    public func prepare(with type: BEAddDataType, category: BECategory?) {
        self.prepare()

        self.type = type
        self.category = category
        self.topBar.leftViews.append(self.categoryLogo)
        self.customBottomBar.centerViews.append(self.dateLabel)
    }

    override func prepare() {

        super.prepare()

        depth = Depth(offset: Offset.init(horizontal: 0, vertical: 4), opacity: 0.2, radius: 10)
        cornerRadiusPreset = .cornerRadius4
        self.contentView = self.digits
        self.toolbar = self.topBar
        self.bottomBar = self.customBottomBar
    }

}
