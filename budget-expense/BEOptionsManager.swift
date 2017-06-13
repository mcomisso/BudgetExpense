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
}

final class BESettingsManager {

    static func initializeDefaults() {
        UserDefaults.standard.safeSet(true, forKey: BESettings.hapticFeedbackEnabled.rawValue)
        UserDefaults.standard.safeSet(true, forKey: BESettings.appSoundsEnabled.rawValue)
    }

    static func readSettingForKey(key: BESettings) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

}

extension UserDefaults {
    func safeSet(_ value: Bool, forKey: String) {
        if self.object(forKey: forKey) == nil {
            self.set(value, forKey: forKey)
        }
    }
}
