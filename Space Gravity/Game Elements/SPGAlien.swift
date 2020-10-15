//
//  SPGAlien.swift
//  Space Gravity
//
//  Created by John Champion on 4/30/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 An alien object. Aliens follow the ship and will destroy the ship if it makes contact.
 */
class SPGAlien: SPGNode {
    
    /// The speed of the alien spacecraft.
    var alienSpeed: CGFloat = 0

    /**
    Properly instanciates an alien object.
    - parameter position: The position in which the alien is to spawn.
    */
    init(withPosition position: CGPoint, speed: CGFloat) {
        super.init(texture: nil, color: .green, size: CGSize(width: 100, height: 100))
        
        self.name = "alien"
        self.position = position
        self.alienSpeed = speed
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func followShip(shipPoint: CGPoint) {
        // Pathagorean theorem
        let xLeg = shipPoint.x - self.position.x
        let yLeg = shipPoint.y - self.position.y
        let hypotenuse = sqrt(pow(xLeg, 2) + pow(yLeg, 2))
        
        let factor = self.alienSpeed / hypotenuse
        let newVelocity = CGVector(dx: xLeg*factor, dy: yLeg*factor)
        
        self.run(SKAction.move(by: newVelocity, duration: 0))
    }
}
