//
//  BENotificationCenterManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

final class BEUserNotificationManager {

    func requestPermission() {

        DispatchQueue.main.async {

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                if success {
                    // Continue
                    UIApplication.shared.registerForRemoteNotifications()
                } else if let e = error {
                    print(e.localizedDescription)
                }
            }

        }

    }

}
