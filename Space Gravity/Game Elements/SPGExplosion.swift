//
//  SPGExplosion.swift
//  Space Gravity
//
//  Created by John Champion on 4/9/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class SPGExplosion: SKSpriteNode {
    
    /// The frames of the explosion animation.
    var explosionFrames: [SKTexture] {
        let explosionAnimatedAtlas = SKTextureAtlas(named: "Explosion")
        var frames: [SKTexture] = []
        
        let numImages = explosionAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let textureName = "explosion\(i)"
            frames.append(explosionAnimatedAtlas.textureNamed(textureName))
        }
        
        return frames
    }
    
    /**
     Properly instanciates a SPGExplosion object.
     - parameter point: The point which the explosion is supposed to spawn.
     */
    init(atPoint point: CGPoint) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 150, height: 150))
        self.position = point
        
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Triggers the explosion animation, then destorys the object
     */
    func explode(completion: @escaping () -> ()) {
        self.run(SKAction.animate(with: self.explosionFrames, timePerFrame: 0.05)) {
            self.removeFromParent()
            completion()
        }
    }
}
