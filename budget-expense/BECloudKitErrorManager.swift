//
//  BECloudKitErrorManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 12/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

enum BECloudKitOperationType {
    case save, delete, edit
}

final class BECloudKitErrorManager {

    let operationQueue: OperationQueue

    let manager = BECloudKitManager.shared

    init() {
        self.operationQueue = OperationQueue()
        self.operationQueue.name = "com.mcomisso.CloudKitErrorManager"
    }

    func addRetryOperation(operationType: BECloudKitOperationType, record: CKRecord) {
//        self.operationQueue.addOperation { [weak self] in
//            switch operationType {
//            case .delete:
//                fatalError()
//            }
//        }
    }
}
