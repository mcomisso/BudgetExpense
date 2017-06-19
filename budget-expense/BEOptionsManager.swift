//
//  BEOptionsManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit


fileprivate let baseName = "com.mcomisso.budget-expense."

enum BESettings: String {

    // Enabled for haptic feedback support
    case hapticFeedbackEnabled

    // Enabled for UI sounds
    case appSoundsEnabled

    // Enabled when a first run is needed
    case needsFirstRun

    // Enabled when iCloud is available (sync)
    case iCloudEnabled

    // Enabled for automatic gathering of currency
    case automaticGeolocation



    /// Appends a base name to every rawValue of BESetting enum
    fileprivate var extendedName: String {
        return baseName.appending(self.rawValue)
    }


    /// Returns the boolean value saved inside UserDefaults for the current setting
    var boolValue: Bool {
        return self.readSettingForKey(key: self)
    }


    /// Private function to retrieve the boolean value of a choosen `BESettings` from UserDefaults
    ///
    /// - Parameter key: The selected key to retrieve
    /// - Returns: Returns false if not found, or its value if found
    private func readSettingForKey(key: BESettings) -> Bool {
        return UserDefaults.standard.bool(forKey: baseName.appending(key.rawValue))
    }


    /// Set a new boolean value to UserDefaults
    ///
    /// - Parameter value: Boolean input to represent the BESettings
    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: baseName.appending(self.rawValue))
        UserDefaults.standard.synchronize()
    }

}

final class BESettingsManager {


    /// Initialize all standard value for every BESetting enum. Saves only if not found.
    static func initializeDefaults() {
        UserDefaults.standard.safeSet(true, forKey: BESettings.hapticFeedbackEnabled.extendedName)
        UserDefaults.standard.safeSet(true, forKey: BESettings.appSoundsEnabled.extendedName)
        UserDefaults.standard.safeSet(true, forKey: BESettings.needsFirstRun.extendedName)
        UserDefaults.standard.safeSet(false, forKey: BESettings.iCloudEnabled.extendedName)
        UserDefaults.standard.safeSet(true, forKey: BESettings.automaticGeolocation.extendedName)
    }

}
