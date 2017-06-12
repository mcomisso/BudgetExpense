//
//  BECloudKitHelper.swift
//  budget-expense
//
//  Created by Matteo Comisso on 12/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CloudKit

class BECloudKitHelper {

    private let container = CKContainer.default()

    private let publicDatabase: CKDatabase
    private let privateDatabase: CKDatabase

    init() {

        self.publicDatabase = self.container.publicCloudDatabase
        self.privateDatabase = self.container.privateCloudDatabase

        self.checkAccountStatus()

        NotificationCenter.default.addObserver(forName: Notification.Name.CKAccountChanged, object: nil, queue: nil) { [weak self] (note) in
            // read note
            self?.checkAccountStatus()
        }
    }

    func checkAccountStatus() {

        self.container.accountStatus { (status, error) in

            print("Checking account status: \(status.rawValue)")

            if let e = error {
                print(e)
            }


            switch status {

            case .available:
                // The user’s iCloud account is available and may be used by this app.

                // Public is shared between all users
                print("Account available")

            case .couldNotDetermine:
                // Indicates that an error occurred during an attempt to retrieve the account status.

                fatalError()

            case .noAccount:
                // The user’s iCloud account is not available because no account information has been provided for this device.
                
                fatalError()
                
            case .restricted:
                // Restricted from other stuff
                
                fatalError()
            }
            
        }
    }

}
