//
//  AppDelegate.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import CloudKit
import Iconic


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: BEAppCoordinator?

    var window: UIWindow?

    let locationManager = BELocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // These settings must be initialized before instantiating the app coordinator
        BESettingsManager.initializeDefaults()

        window = UIWindow()

        self.coordinator = BEAppCoordinator(window: window)
        self.coordinator?.start()

        window?.makeKeyAndVisible()


        // Dispatch low priority init on a background queue
        DispatchQueue.global(qos: .background).async {

            // Iconic register
            FontAwesomeIcon.register()

            // Load initial data if database is empty
            if BERealmManager.shared.isEmpty {
                BEInitialData.loadIntoRealm()
            }

            BECurrencyWebService().fetchUpdatedRates()
        }

        return true
    }
}
