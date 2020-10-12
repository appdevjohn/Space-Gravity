//
//  SPGGoal.swift
//  Space Gravity
//
//  Created by John Champion on 4/27/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 In adventure mode, objects of this class represent the end goal of each level.
 */
class SPGGoal: SPGNode {
    
    /**
     Properly instanciates a goal object.
     - parameter position: The position in which the ship is to spawn.
     */
    init(withPosition position: CGPoint) {
        // Instanciating itself
        super.init(texture: nil, color: SKColor.white, size: CGSize(width: 50, height: 50))
        
        // Setting up itself
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = position
        self.zPosition = 1
        self.name = "goal"
        
        // Setting up physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = ContactCategory.goal.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
