//
//  BEUtils.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation

struct BEUtils {

    static func formatNumberToCurrency(number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.allowsFloats = true
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: number) ?? ""
    }
}
