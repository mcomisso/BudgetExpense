//
//  CloudKitAccount.swift
//  budget-expense
//
//  Created by Matteo Comisso on 11/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitAccount: BEAccount {

    static let RecordType = "Account"

    let record: CKRecord

    var id: String {
        get {
            return self.record.recordID.recordName
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

    var name: String {
        get {
            return record.object(forKey: "name") as! String
        }

        set {
            self.record.setObject(newValue as NSString, forKey: "name")
        }
    }

    var currency: String {
        get {
            return record.object(forKey: "currency") as! String
        }
        set {
            self.record.setObject(newValue as NSString, forKey: "currency")
        }
    }

    init(account: BEAccount) {
        self.record = CKRecord(recordType: CloudKitAccount.RecordType)
        self.currency = account.currency
        self.name = account.name
    }

    init(record: CKRecord) {
        self.record = record
    }
}
