//
//  SPGShip.swift
//  Space Gravity
//
//  Created by John Champion on 3/26/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 The class of the ship object.
 
 To use this properly, simply add an instance of this class to any scene.  In the `update` function of the scene, call the `updateAcceleration` function of this class to make the ship move.
 */
class SPGShip: SPGNode {
    
    /// Boolean value indicating whether or not the ship is accelerating.
    var thrusting = false
    
    /// Current Velocity of the ship.
    var velocity = CGVector.zero
    
    /// Current fuel level of the ship.  Value is between 0 and 1.
    var fuel: CGFloat = 1.0
    
    /// The rate at which fuel is consumed when the ship is thrusting.
    var fuelConsumptionRate: CGFloat = 0.0075
    
    /// The rate at which fuel is replenished when the ship is not thrusting.
    var fuelReplenishRate: CGFloat = 0.015
    
    /// Represents whether or not the ship used all of its fuel.  The ship will then be in a state of recharge and will be unable to thrust.
    var outOfFuel = false
    
    /// Particle effects for thrust on the left side of the ship.
    var thrustLeft = SKEmitterNode(fileNamed: "ShipThrust.sks")
    
    /// Particle effects for thrust on the right side of the ship.
    var thrustRight = SKEmitterNode(fileNamed: "ShipThrust.sks")
    
    var audioNode = SPGAudioNode()
    
    // MARK: -
    
    /**
     Properly instanciates a ship object.
     - parameter position: The position in which the ship is to spawn.
     */
    convenience init(withPosition position: CGPoint) {
        // Instanciating itself
        self.init(texture: SKTexture(imageNamed: "ship.png"), color: SKColor.white, size: CGSize(width: 46, height: 50))
        
        // Setting up itself
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = position
        self.zPosition = 1
        self.name = "ship"
        
        // Setting up physics body
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ship.png"), alphaThreshold: 0.05, size: self.size)
        self.physicsBody?.categoryBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        
        // Adding thrust
        self.thrustLeft?.position = CGPoint(x: -0.5*self.size.width + 7, y: 0)
        self.thrustRight?.position = CGPoint(x: 0.5*self.size.width - 7, y: 0)
        self.thrustLeft?.zPosition = -1
        self.thrustRight?.zPosition = -1
        self.addChild(self.thrustLeft!)
        self.addChild(self.thrustRight!)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.addChild(audioNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    /**
     Updates the velocity and rotation of the ship only if the thrusting property is true.
     - parameter point: The point which is affecting the acceleration of the ship.
     */
    func updateAcceleration(withPoint point: CGPoint) {
        // If the ship is thrusting, adjust velocity
        if self.thrusting && !self.outOfFuel {
            // Pathagorean theorem
            let xLeg = self.position.x - point.x
            let yLeg = self.position.y - point.y
            let hypotenuse = sqrt(pow(xLeg, 2) + pow(yLeg, 2))
            
            // Formulas for calculating velocity
            let dx = -1*((0.2*xLeg)/hypotenuse) + self.velocity.dx/1.026
            let dy = -1*((0.2*yLeg)/hypotenuse) + self.velocity.dy/1.026
            
            // Determing the angle to display the ship
            var radians = atan(yLeg/xLeg) - 3.14159/2
            if point.x < self.position.x {
                radians = radians + 3.14159
            }
            self.run(SKAction.rotate(toAngle: radians, duration: 0))
            self.thrustLeft?.run(SKAction.rotate(toAngle: -1*radians, duration: 0))
            self.thrustRight?.run(SKAction.rotate(toAngle: -1*radians, duration: 0))
            
            // Setting the thrust particle effects for thrusting
            self.thrustLeft?.emissionAngle = radians - 1.5708
            self.thrustRight?.emissionAngle = radians - 1.5708
            self.thrustLeft?.particleSpeed = 500
            self.thrustRight?.particleSpeed = 500
            self.thrustLeft?.particleBirthRate = 500
            self.thrustRight?.particleBirthRate = 500
            
            // Setting velocity
            self.velocity = CGVector(dx: dx, dy: dy)
            
            // Updating fuel
            self.fuel -= self.fuelConsumptionRate
            if self.fuel < 0.0 {
                self.outOfFuel = true
            }

            // play propulsion sound 
            if !self.outOfFuel {
                audioNode.playPropulsionSound()
            }
        } else {
            audioNode.stopPropulsionSound()
            
            // Setting the thrust particle effects for idling
            self.thrustLeft?.particleSpeed = 75
            self.thrustRight?.particleSpeed = 75
            self.thrustLeft?.particleBirthRate = 12
            self.thrustRight?.particleBirthRate = 12
            
            // Updating fuel
            if fuel < 1.0 {
                self.fuel += self.fuelReplenishRate
            }
            
            if fuel > 1.0 {
                self.fuel = 1.0
                self.outOfFuel = false
            }
        }
        
        self.run(SKAction.move(by: self.velocity, duration: 0))
    }
}
