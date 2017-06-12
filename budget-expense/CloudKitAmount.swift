//
//  CloudKitAmount.swift
//  budget-expense
//
//  Created by Matteo Comisso on 11/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitAmount: BEAmount {

    // Record type

    static let RecordType = "Amount"

    // Private vars

    public let record: CKRecord

    var id: String {
        return self.record.recordID.recordName
    }

    var amount: Double {
        get {
            return self.record.object(forKey: "amount") as! Double
        }
        set {
            self.record.setObject(NSNumber(value: newValue), forKey: "amount")
        }
    }

    var isExpense: Bool {
        get {
            return self.record.object(forKey: "isExpense") as! Bool
        }
        set {
            self.record.setObject(newValue as NSNumber, forKey: "isExpense")
        }
    }

    var notes: String {
        get {
            return self.record.object(forKey: "notes") as! String
        }
        set {
            self.record.setObject(newValue as NSString, forKey: "notes")
        }
    }

    var expenseDate: Date? {
        get {
            return self.record.object(forKey: "expenseDate") as? Date
        }

        set {
            self.record.setObject(newValue! as NSDate, forKey: "expenseDate")
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
