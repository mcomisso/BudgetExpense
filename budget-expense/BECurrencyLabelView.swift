//
//  BECurrencyLabelView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 21/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import Material

final class BECurrencyLabelView: UIView {

    @IBOutlet weak var digitsText: UILabel!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var currentCurrency: UILabel!
    @IBOutlet weak var convertCurrency: UIButton!

    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!

    private var temporaryValue: String = ""

    private var baseCurrency: BECurrency? {
        let base = BERealmManager.shared.getBaseCurrency()
        return base
    }

    private var activeCurrency: BECurrency? {
        let active = BERealmManager.shared.getActiveCurrency()

        if let a = active {
            self.currentCurrency.text = a.currency.capitalized
        }

        return active
    }

    func setCurrency(currency: BECurrency) {
        self.currentCurrency.text = currency.currency.capitalized

    }

    @IBAction func didTouchConversion(_ sender: Any) {
        if let base = BERealmManager.shared.getBaseCurrency(),
            let value = self.digitsText.text?.toNumber() {
            self.temporaryValue = self.digitsText.text!

            let converted = base.value * value.doubleValue

            self.digitsText.text = String(converted)
        }
    }


    @IBAction func didCompleteConversion(_ sender: Any) {
        self.currentCurrency.text = self.temporaryValue
    }

    @IBInspectable
    var textColor: UIColor {
        get {
            return self.digitsText.textColor
        }
        set {
            self.digitsText.textColor = newValue
        }
    }

    

}


extension String {
    func toNumber() -> NSNumber? {
        if let double = Double(self) {
            return NSNumber.init(value: double)
        }
        return nil
    }
}
