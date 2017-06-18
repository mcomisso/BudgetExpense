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

    case hapticFeedbackEnabled
    case appSoundsEnabled
    case needsFirstRun
    case iCloudEnabled
    case automaticGeolocation

    fileprivate var extendedName: String {
        return baseName.appending(self.rawValue)
    }

    var boolValue: Bool {
        return self.readSettingForKey(key: self)
    }

    private func readSettingForKey(key: BESettings) -> Bool {
        return UserDefaults.standard.bool(forKey: baseName.appending(key.rawValue))
    }

    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: baseName.appending(self.rawValue))
        UserDefaults.standard.synchronize()
    }

}

final class BESettingsManager {

    static func initializeDefaults() {
        UserDefaults.standard.safeSet(true, forKey: BESettings.hapticFeedbackEnabled.extendedName)
        UserDefaults.standard.safeSet(true, forKey: BESettings.appSoundsEnabled.extendedName)
        UserDefaults.standard.safeSet(true, forKey: BESettings.needsFirstRun.extendedName)
        UserDefaults.standard.safeSet(false, forKey: BESettings.iCloudEnabled.extendedName)
        UserDefaults.standard.safeSet(true, forKey: BESettings.automaticGeolocation.extendedName)
    }

}
