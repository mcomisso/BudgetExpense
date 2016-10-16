//
//  BERealm.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class Accounts: Object {
    dynamic var name = ""
    let amounts = List<Amount>()
}

class Amount: Object {
    dynamic var date: Date = Date()
    dynamic var amount = 0.0
    dynamic var isExpense = true

}

class BERealmManager {
    static let shared = BERealmManager()

    fileprivate let realm = try! Realm()

    func getAmount() -> String {
        let amounts = realm.objects(Amount.self)

        var memout = 0.0
        for amount in amounts {
            memout = memout + amount.amount
        }
        return String(memout)
    }

    func saveAmount(amount: Double) {
        let amountObject = Amount()
        amountObject.date = Date()
        amountObject.amount = amount

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
