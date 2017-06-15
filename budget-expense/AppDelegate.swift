//
//  AppDelegate.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications
import Iconic


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: BEAppCoordinator?

    var window: UIWindow?

    let locationManager = BELocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // initialize standard settings
        BESettingsManager.initializeDefaults()

        window = UIWindow()
        self.coordinator = BEAppCoordinator(window: window)
        self.coordinator?.start()

        window?.makeKeyAndVisible()


        DispatchQueue.global(qos: .background).async {
            // Iconic register
            FontAwesomeIcon.register()

            // Location to fetch
            self.locationManager.requestAuthorization()

            // Load initial data

            if BERealmManager.shared.isEmpty {
                BEInitialData.loadIntoRealm()
            }
        }

        self.registerForNotifications(application: application)

        return true
    }


}

extension AppDelegate {

    func registerForNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                // Continue
                application.registerForRemoteNotifications()
            } else if let e = error {
                print(e.localizedDescription)
            }
        }
    }

}

