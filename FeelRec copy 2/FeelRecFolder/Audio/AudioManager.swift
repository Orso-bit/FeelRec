//
//  AudioManager.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 01/02/25.
//

import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    func setupAudioSession() {
        do {
            let audioSession = try AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
}
