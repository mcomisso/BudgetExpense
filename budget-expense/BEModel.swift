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
    dynamic var id = UUID.init().uuidString

    dynamic var date: Date = Date()
    dynamic var amount = 0.0
    dynamic var isExpense = true
    dynamic var notes = ""

    dynamic var category: CategoryModel?


    override class func primaryKey() -> String? { return "id" }

    func day() -> Date {
        let components = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year], from: self.date)
        return components.date!
    }

    override var description: String {

        let expense = self.isExpense ? "expense" : "income"

        return "New \(expense) - Date: \(self.date.description) Amount: \(self.amount) Notes: \(self.notes)"
    }
}


class CategoryModel: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var icon = NSData()
    dynamic var color = ""
}

class BERealmManager {
    static let shared = BERealmManager()

    fileprivate let realmConfiguration: Realm.Configuration = {
        let conf = Realm.Configuration(inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: { (migration, version) in
            // Deal with migration
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: { (a, b) -> Bool in
            return true
        })

        return conf
    }()

    var realm: Realm {
        get {
            do {
                return try Realm.init(configuration: self.realmConfiguration)
            } catch {
                fatalError(error.localizedDescription)
            }

        }
    }

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
        return self.realm.objects(Amount.self).sorted(byKeyPath: "date", ascending: false)
    }

    func getDataForDay(day: Date) -> Results<Amount> {
        return self.realm.objects(Amount.self).filter("date == %@", day)
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



    func delete(amount: Amount, completion: @escaping ((Bool)-> Void)) {
        var success: Bool = false
        defer {
            DispatchQueue.main.async {
                completion(success)
            }
        }

        let realm = self.realm
        do {
            try realm.write {
                realm.delete(amount)
                success = true
            }
        } catch {
            success = false
        }



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

        let realm = self.realm

        do {
            try realm.write {
                realm.add(amountObject)
            }
        }
        catch {
            fatalError("Something gone wrong: \(error)")
        }
    }
}
