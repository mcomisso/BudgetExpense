//
//  BERealm.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

final class BERealmManager {
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

    func addNotification(callback: @escaping NotificationBlock) -> NotificationToken {

        let token = self.realm.addNotificationBlock(callback)
        return token
    }

}


//MARK:- AMOUNTS
fileprivate typealias BERealmAmountMethods = BERealmManager
extension BERealmAmountMethods {
    /// Get the current amount
    ///
    /// - returns: A string representing the current amount
    func getAmount() -> NSNumber {
        let amount = realm.objects(Amount.self).map { $0.isExpense ? -$0.amount : $0.amount }.reduce(0.0) { $0 + $1 }
        return NSNumber(value: amount)
    }

    func getAvailableDays() -> [Date] {
        return Array(Set(Array(self.realm.objects(Amount.self).sorted(byKeyPath: "date", ascending: true)).map { $0.date.startOfDay }))
    }

    /// Get Amount data for a tableView representation
    ///
    /// - returns: Returns a Realm results with amount
    func getWeekDataForTableView() -> Results<Amount> {
        return self.realm.objects(Amount.self).sorted(byKeyPath: "date", ascending: false)
    }

    func getDataForDay(day: Date) -> [Amount] {
        return Array(self.realm.objects(Amount.self).filter("date BETWEEN %@", [day.startOfDay, day.endOfDay]))
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

    func delete(amount: Amount, completion: ((Bool)-> Void)? = nil) {
        var success: Bool = false
        defer {
            DispatchQueue.main.async {
                guard let completion = completion else { return }
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

extension BERealmManager {

    func saveCategory(_ category: BECategory) {

        let realm = self.realm

        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            fatalError("Something wrong when saving category. \(error.localizedDescription)")
        }
    }

    /// Get the list of categories
    ///
    /// - returns: Return a Results list of categories
    func getCategories() -> [BECategoryProtocol] {
        return Array(realm.objects(BECategory.self))
    }

}

//MARK: UTILS
extension BERealmManager {

    var isEmpty: Bool {
        get {
            return self.realm.isEmpty
        }
    }
}
