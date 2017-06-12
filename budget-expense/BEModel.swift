//
//  BERealm.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

class Account: Object {
    dynamic var id = 0
    dynamic var name = ""
    let amounts = List<Amount>()
}

class Amount: Object {
    dynamic var date: Date = Date()
    dynamic var amount = 0.0
    dynamic var isExpense = true
    dynamic var notes = ""

    dynamic var category: CategoryModel?
}


class CategoryModel: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var icon = NSData()
    dynamic var color = ""
}

class BERealmManager {
    static let shared = BERealmManager()

    fileprivate let realm = try! Realm()

    /// Get the current amount
    ///
    /// - returns: A string representing the current amount
    func getAmount() -> NSNumber {
        let amount = realm.objects(Amount.self).map { $0.isExpense ? -$0.amount : $0.amount }.reduce(0.0) { $0 + $1 }
        return NSNumber(value: amount)
    }


    /// Get Amount data for a tableView representation
    ///
    /// - returns: Returns a Realm results with amount
    func getWeekDataForTableView() -> Results<Amount> {
        return self.realm.objects(Amount.self)
    }


    /// Gets the weekly data. The set date is the most recent.
    ///
    /// - parameter date: The date to start (topmost date)
    ///
    /// - returns: Return an array of double values
    func getWeekData(to date: Date = Date()) -> [Double] {
        let amounts = self.realm.objects(Amount.self)
        return amounts.map { $0.amount }
    }


    /// Get the list of categories
    ///
    /// - returns: Return a Results list of categories
    func getCategories() -> Results<CategoryModel>? {
        return realm.objects(CategoryModel.self)
    }


    /// Save an amount
    ///
    /// - parameter amount: Value of the amount
    /// - parameter type:   Expense or Income
    /// - parameter notes:  Optional notes
    /// - parameter date:   Optional date
    func save(amount: Double, type: BEAddDataType, notes: String = "", date: Date = Date()) {
        let amountObject = Amount()
        amountObject.date = date
        amountObject.notes = notes
        amountObject.amount = amount
        switch type {
        case .expense:
            amountObject.isExpense = true
        case .income:
            amountObject.isExpense = false
        }

        do {
            try self.realm.write {
                self.realm.add(amountObject)
            }
        }
        catch _ {
            fatalError("Something gone wrong")
        }
    }
}
