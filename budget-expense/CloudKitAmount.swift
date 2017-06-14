//
//  CloudKitAmount.swift
//  budget-expense
//
//  Created by Matteo Comisso on 11/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitAmount: BEAmountProtocol {

    // Record type

    static let RecordType = "Amount"

    // Private vars

    public let record: CKRecord

    var id: String {
        return self.record.recordID.recordName
    }

    var amount: Double {
        get {
            return self.record["amount"] as! Double
        }
        set {
            self.record["amount"] = NSNumber(value: newValue)
        }
    }

    var isExpense: Bool {
        get {
            return self.record["isExpense"] as! Bool
        }
        set {
            self.record["isExpense"] = newValue as NSNumber
        }
    }

    var notes: String {
        get {
            return self.record["notes"] as! String
        }
        set {
            self.record["notes"] = newValue as NSString
        }
    }

    var expenseDate: Date? {
        get {
            return self.record["expenseDate"] as? Date
        }

        set {
            self.record["expenseDate"] = newValue! as NSDate
        }
    }

    var creationDate: Date? {
        get {
            return self.record.creationDate
        }
    }

    var modificationDate: Date? {
        get {
            return self.record.modificationDate
        }
    }

    //MARK: Initializers

    init(amount: Double, isExpense: Bool, notes: String, date: Date) {
        self.record = CKRecord(recordType: CloudKitAmount.RecordType)

        self.amount = amount
        self.isExpense = isExpense
        self.notes = notes
        self.expenseDate = date
    }

    init(record: CKRecord) {
        self.record = record
    }
}
