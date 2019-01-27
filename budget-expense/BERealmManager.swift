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
        let conf = Realm.Configuration(inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 2, migrationBlock: { (migration, version) in
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

//    func addNotification(callback: @escaping NotificationBlock) -> NotificationToken {
//
////        let token = self.realm.addNotificationBlock(callback)
////        return token
//    }

}


//MARK:- CURRENCY
fileprivate typealias BERealmCurrencyMethods = BERealmManager
extension BERealmCurrencyMethods {

    func listCurrencies() -> [String] {
        let realm = self.realm

        return realm.objects(BECurrency.self).sorted(byKeyPath: "currency").map { $0.currency }
    }

    func setCurrency(forActiveCurrency: Bool, currencyCode: String) {

        let realm = self.realm

        // Get the currency for the requested currencyCode
        guard let newCurrentCurrency = realm.object(ofType: BECurrency.self, forPrimaryKey: currencyCode) else { return }

        // Get the currently active/base currency
        var oldCurrency: BECurrency? = nil

        if forActiveCurrency {
            // Set a new active currency
            oldCurrency = self.getActiveCurrency()
        } else {
            oldCurrency = self.getBaseCurrency()
        }

        // Swap properties

        try? realm.write {
            if forActiveCurrency {
                oldCurrency?.isActiveCurrency = false
                newCurrentCurrency.isActiveCurrency = true
            } else {
                oldCurrency?.isBaseCurrency = false
                newCurrentCurrency.isBaseCurrency = true
            }
        }
    }

    func getCurrencyFromCode(_ code: String) -> BECurrency? {
        let realm = self.realm

        return realm.object(ofType: BECurrency.self, forPrimaryKey: code)
    }

    func getBaseCurrency() -> BECurrency? {
        return self.realm.objects(BECurrency.self).filter("isBaseCurrency = true").first
    }

    func getActiveCurrency() -> BECurrency? {
        return self.realm.objects(BECurrency.self).filter("isActiveCurrency = true").first
    }

    func saveCurrencies(_ currencies: [BECurrency]) {
        let realm = self.realm

        do {
            try realm.write {
                realm.add(currencies, update: true)
            }
        } catch {
            print("Error while saving currencies: \(error)")
        }

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

        let dateResults = Set(self.realm.objects(Amount.self).sorted(byKeyPath: "date", ascending: false).map { $0.date.dateAt(.startOfDay) })

        return Array(dateResults).sorted(by: { (lhs, rhs) -> Bool in
            if lhs.compare(rhs) == ComparisonResult.orderedAscending {
                return false
            } else {
                return true
            }
        })
    }

    /// Get Amount data for a tableView representation
    ///
    /// - returns: Returns a Realm results with amount
    func getWeekDataForTableView() -> Results<Amount> {
        return self.realm.objects(Amount.self).sorted(byKeyPath: "date", ascending: false)
    }

    func getDataForDay(day: Date) -> Results<Amount> {
        return self.realm.objects(Amount.self).filter("date BETWEEN %@", [day.dateAt(.startOfDay), day.dateAt(.endOfDay)]).sorted(byKeyPath: "date", ascending: false)
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
    func save(amount: Double, type: BEAddDataType, notes: String = "", date: Date = Date(), category: BECategory? = nil) {
        let amountObject = Amount()
        amountObject.date = date
        amountObject.notes = notes
        amountObject.amount = amount
        amountObject.category = category

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

    func deleteAllData() {
        let realm = self.realm
        try? realm.write {
            realm.deleteAll()
        }

        BEInitialData.loadIntoRealm()
    }

    var isEmpty: Bool {
        get {
            return self.realm.isEmpty
        }
    }
}
