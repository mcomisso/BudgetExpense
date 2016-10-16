//
//  BERealm.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    dynamic var id = 0
    dynamic var name = ""
    let amounts = List<Amount>()
}

class Amount: Object {
    dynamic var date: Date = Date()
    dynamic var amount = 0.0
    dynamic var isExpense = true

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

    func getAmount() -> String {
        let amounts = realm.objects(Amount.self)

        var memout = 0.0
        for amount in amounts {
            if amount.isExpense {
                memout = memout - amount.amount
            } else {
                memout = memout + amount.amount
            }
        }
        return String(memout)
    }

    func getWeekDataForTableView() -> Results<Amount> {
        return realm.objects(Amount.self)
    }

    func getWeekData() -> [Double] {
        let amounts = realm.objects(Amount.self)
        return amounts.map { $0.amount }
    }

    func saveAmount(amount: Double, type: BEAddDataType) {
        let amountObject = Amount()
        amountObject.date = Date()
        amountObject.amount = amount
        switch type {
        case .expense:
            amountObject.isExpense = true
        default:
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
