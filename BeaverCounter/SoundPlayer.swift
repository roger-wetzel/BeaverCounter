//
//  SoundPlayer.swift
//  Beaver Counter
//
//  Copyright © 2020 Roger Wetzel. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundPlayer {
    static func play(_ fileURLWithPath: String) {
        let url = URL(fileURLWithPath: fileURLWithPath)
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID);
    }

    static func play(_ systemSoundID: SystemSoundID) {
        AudioServicesPlayAlertSound(systemSoundID)
    }
}
