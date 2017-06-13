//
//  BESoundPlayer.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import AudioToolbox

enum BECustomSounds: String {
    case beepOff
    case beepOn
    case click

    func toURL() -> URL {
        switch self {
        case .beepOff:
            return R.file.beep_short_offAif()!
        case .beepOn:
            return R.file.beep_short_onAif()!
        case .click:
            return R.file.clickAif()!
        }
    }
}

final class BESoundPlayer {

    // SOUND FILES

    static func play(sound: BECustomSounds) {

        guard BESettingsManager.readSettingForKey(key: .appSoundsEnabled) == true else { return }

        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sound.toURL() as CFURL, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }

}
