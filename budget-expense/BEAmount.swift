//
//  BEAmount.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class Amount: BEBaseModel {

    dynamic var date: Date = Date()
    dynamic var amount = 0.0
    dynamic var isExpense = true
    dynamic var notes = ""

    dynamic var category: BECategory?

    func day() -> Date {
        let components = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year], from: self.date)
        return components.date!
    }

    override var description: String {

        let expense = self.isExpense ? "expense" : "income"

        return "New \(expense) - Date: \(self.date.description) Amount: \(self.amount) Notes: \(self.notes)"
    }
}
