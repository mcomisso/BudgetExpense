//
//  AppDelegate.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: BEAppCoordinator?

    var window: UIWindow?

    let locationManager = BELocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.coordinator = BEAppCoordinator()

        window = UIWindow()
        window?.rootViewController = self.coordinator?.rootViewController
        window?.makeKeyAndVisible()

        // Location to fetch
        self.locationManager.requestAuthorization()

        return true
    }

}

