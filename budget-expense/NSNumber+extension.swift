//
//  NSNumber+extension.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

extension NSNumber {

    func toCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.allowsFloats = true
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: self) ?? ""
    }
    
}
