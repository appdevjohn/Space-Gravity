//
//  SPGAsteroid.swift
//  Space Gravity
//
//  Created by John Champion on 3/26/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 The asteroid class. Used in both the classic and adventure modes.
 
 Call `initiateFlyBy` to have the asteroid wrap itself in classic mode.
 */
class SPGAsteroid: SPGNode {
    
    /// Current velocity of the asteroid.
    var velocity = CGVector.zero
    
    /**
     Properly instanciates an asteroid object.
     */
    init() {
        // Instanciating itself
        super.init(texture: SKTexture(imageNamed: "asteroid.png"), color: [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.cyan, UIColor.magenta, UIColor.brown, UIColor.gray, UIColor.white].randomElement()!, size: CGSize(width: 50, height: 50))
        
        // Setting up itself
        self.zPosition = 1
        self.name = "asteroid"
        
        // Setting up the physics body
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
        
        // Setting random initial rotation
        self.zRotation = CGFloat.random(in: 0...6.28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets up the asteroid's position and velocity so it can fly through the scene properly.
     For use in Classic Mode only.
     
     HOW ASTEROIDS ARE SPAWNED IN THE ORIGINAL SPACE GRAVITY
     
     A point was chosen at somepoint within the game scene no closer than
     75 pixels from the edge of the screen
     
     Random velocities (within reason) were given to each asteroid
     The original formula was (rand()%10000 + 1) / 1000 - 5
     
     Given a velocity and a required point to pass through, a starting
     position could be calculated outside of view, where the asteroid would spawn
     
     Asteroids do not wrap.  This process is repeated every time the asteroid
     leaves the view.
     */
    func initiateFlyBy() {
        if self.scene != nil {
            // Distance from edge of screen where asteroids must pass through
            let scenePadding: CGFloat = 75
            
            // This is the point in the scene where the asteroid must pass through
            let passThroughPoint = CGPoint(x: CGFloat.random(in: scenePadding...(self.scene?.frame.width)!-scenePadding), y: CGFloat.random(in: scenePadding...(self.scene?.frame.height)!-scenePadding))
            
            // The original formula for velocity
            let velocity = CGVector(dx: CGFloat.random(in: 1...10000)/1000 - 5, dy: CGFloat.random(in: 1...10000)/1000 - 5)
            
            // Setting the position outside of view
            var position = CGPoint.zero
            if velocity.dx > 0 {
                position.x = -50
            } else {
                position.x = (self.scene?.frame.width)! + 50
            }
            position.y = (passThroughPoint.x - position.x) * (-1*velocity.dy / velocity.dx) + passThroughPoint.y
            
            // Apply these calculations to the actual asteroid's values
            self.position = position
            self.velocity = velocity
            self.physicsBody?.angularVelocity = CGFloat.random(in: -1.25...1.25)
            
        } else {
            print("Asteroid not in scene.  Cannot setup flyby.")
        }
    }
}
