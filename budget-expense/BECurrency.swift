//
//  BECurrency.swift
//  budget-expense
//
//  Created by Matteo Comisso on 17/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class BECurrency: Object {

    dynamic var currency: String = ""
    dynamic var value: Double = 0.0


    convenience init(currency: String, value: Double) {
        self.init()

        self.currency = currency
        self.value = value
    }

    override class func primaryKey() -> String? { return "currency" }

}