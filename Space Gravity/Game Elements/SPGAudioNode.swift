//
//  SPGAudioNode.swift
//  Space Gravity
//
//  Created by Zane Helton on 4/7/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class SPGAudioNode: SKNode {
    /// Sound effects
    var pointSound = SKAudioNode(fileNamed: "Point.wav")
    var propulsionSound = SKAudioNode(fileNamed: "Propulsion.wav")

    /// A switch to prevent the propulsion sound from cutting itself
    private var isPlayingPropulsionSound = false
    
    override init() {
        super.init()
        
        pointSound.autoplayLooped = false
        propulsionSound.autoplayLooped = false
        
        self.addChild(pointSound)
        self.addChild(propulsionSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func playPointSound() {
        if SPGSoundManager.shared.getMute() { return }
        
        // add light variation
        let randomVolume = CGFloat.random(in: 0.3...1)

        pointSound.run(SKAction.changeVolume(to: Float(randomVolume), duration: 0))
        pointSound.run(SKAction.play())
    }
    
    public func playPropulsionSound() {
        if SPGSoundManager.shared.getMute() { return }
        
        if !isPlayingPropulsionSound {
            propulsionSound.run(SKAction.play())
            isPlayingPropulsionSound = true
        }
    }
    
    public func stopPropulsionSound() {
        if isPlayingPropulsionSound {
            propulsionSound.run(SKAction.stop())
            isPlayingPropulsionSound = false
        }
    }
}
