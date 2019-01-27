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

    @objc dynamic var date: Date = Date()
    @objc dynamic var amount = 0.0
    @objc dynamic var isExpense = true
    @objc dynamic var notes = ""

    // Add location object
    @objc dynamic var category: BECategory?

    func day() -> Date {
        let components = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year], from: self.date)
        return components.date!
    }

    override var description: String {

        var descriptionString = ""

        let expense = self.isExpense ? "Expense" : "Income"

        descriptionString.append("New \(expense),  Date: \(self.date.description) Amount: \(self.amount)")

        if notes.isEmpty == false {
            descriptionString.append("Notes: \(self.notes)")
        }

        return descriptionString
    }
}
