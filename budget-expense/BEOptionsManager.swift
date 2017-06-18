//
//  BEOptionsManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit

enum BESettings: String {
    case hapticFeedbackEnabled
    case appSoundsEnabled
    case needsFirstRun
    case iCloudEnabled

    var boolValue: Bool {
        return self.readSettingForKey(key: self)
    }

    private func readSettingForKey(key: BESettings) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }

}

final class BESettingsManager {

    static func initializeDefaults() {
        UserDefaults.standard.safeSet(true, forKey: BESettings.hapticFeedbackEnabled.rawValue)
        UserDefaults.standard.safeSet(true, forKey: BESettings.appSoundsEnabled.rawValue)
        UserDefaults.standard.safeSet(true, forKey: BESettings.needsFirstRun.rawValue)
        UserDefaults.standard.safeSet(false, forKey: BESettings.iCloudEnabled.rawValue)
    }

}
