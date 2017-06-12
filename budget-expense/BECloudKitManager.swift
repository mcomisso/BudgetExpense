//
//  BECloudKitManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 12/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

final class BECloudKitManager: BEManager {

    let container = CKContainer.default()

    let privateDB: CKDatabase
    let publicDB: CKDatabase

    init() {
        self.privateDB = self.container.privateCloudDatabase
        self.publicDB = self.container.publicCloudDatabase
    }

    func getCategories() -> [BECategory]? {
        return nil
    }

    func getWeekData(to date: Date) -> [Double] {
        return []
    }

    func getWeekDataForTableView() -> [BEAmount] {
        return []
    }

    // Current total amount
    func getAmount() -> NSNumber {
        return NSNumber(value: 0)
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
