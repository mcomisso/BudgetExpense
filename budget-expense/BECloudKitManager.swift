//
//  BECloudKitManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 12/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

final class BECloudKitManager: BEManagerAmountProtocol {

    let container = CKContainer.default()

    let privateDB: CKDatabase
    let publicDB: CKDatabase

    let appZone: CKRecordZone

    static let shared = BECloudKitManager()

    private init() {
        self.privateDB = self.container.privateCloudDatabase
        self.publicDB = self.container.publicCloudDatabase

        self.appZone = CKRecordZone(zoneID: CKRecordZoneID(zoneName: "com.mcomisso.budgetexpense.appZone", ownerName: CKCurrentUserDefaultName))
    }


    // SUBSCRIPTIONS

    func loadSubscriptions() {
        let subscription = CKRecordZoneSubscription(zoneID: self.appZone.zoneID)
    }



    func getCategories() -> [BECategoryProtocol]? {
        return nil
    }

    func getWeekData(to date: Date) -> [Double] {
        return []
    }

    func getWeekDataForTableView() -> [BEAmountProtocol] {
        return []
    }

    // Current total amount
    func getAmount() -> NSNumber {
        return NSNumber(value: 0)
    }

    func save(record: CKRecord) {

    }

    func save(amount: Amount) throws {
        let ckAmount = CloudKitAmount(amount: amount.amount, isExpense: amount.isExpense, notes: amount.notes, date: amount.date)

        self.privateDB.save(ckAmount.record) { (record, error) in
            if let ckError = error as? CKError {
                // Handle errors
                print(ckError.localizedDescription)
            } else {
                print("Saved record: \(record.debugDescription)")
            }
        }
    }

    func save(amount: Double, type: BEAddDataType, notes: String, date: Date) {
        let ckAmount = CloudKitAmount(amount: amount, isExpense: type == .expense ? true : false, notes: notes, date: date)

        self.privateDB.save(ckAmount.record) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Saved record: \(record.debugDescription)")
            }
        }
    }
}

extension BECloudKitManager: BEManagerAccountProtocol {

    func createAccount(name: String, currency: String) {
        let account = CloudKitWallet(name: name, currency: currency)

        self.privateDB.save(account.record) { (record, error) in
            if let error = error {
                print(error)
            } else {
                print(record.debugDescription)
            }
        }
    }
}
