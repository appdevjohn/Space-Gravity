//
//  SPGWall.swift
//  Space Gravity
//
//  Created by John Champion on 4/29/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 A wall object, which acts exaclty like asteroids, but can be resized to any size.
 */
class SPGWall: SPGNode {
    
    /**
    Properly instanciates a wall object.
    - parameter position: The position in which the wall is to spawn.
    - parameter size: The size which the wall is to spawn.
    */
    init(withPosition position: CGPoint, andSize size: CGSize) {
        super.init(texture: nil, color: .gray, size: size)
        
        self.name = "wall"
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
