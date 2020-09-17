//
//  SPGSoundManager.swift
//  Space Gravity
//
//  Created by John Champion on 4/11/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import AVFoundation

class SPGSoundManager: NSObject {
    
    /// Singleton variable to access this class.
    static let shared = SPGSoundManager()
    
    /// If the sound is muted, this is true.
    private var isMuted: Bool = UserDefaults.standard.bool(forKey: "muted")
    
    /// The object that will be used to play audio
    private var audioPlayer: AVPlayer?
    
    /**
     Sets the mute value.
     - parameter muted: Whether or not the sounds are muted.
     */
    public func setMute(muted: Bool) {
        self.isMuted = muted
        UserDefaults.standard.set(self.isMuted, forKey: "muted")
    }
    
    /**
     Returns the current isMuted value.
     */
    public func getMute() -> Bool {
        return self.isMuted
    }
    
    public func playPauseSound() {
        if self.isMuted { return }
        guard let url = Bundle.main.url(forResource: "Pause", withExtension: "wav") else { return }

        audioPlayer = AVPlayer(url: url as URL)
        audioPlayer?.play()
    }
    
    public func playButtonSound() {
        if self.isMuted { return }
        guard let url = Bundle.main.url(forResource: "GameStart", withExtension: "wav") else { return }

        audioPlayer = AVPlayer(url: url as URL)
        audioPlayer?.play()
    }
}
