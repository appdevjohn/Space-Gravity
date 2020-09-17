//
//  SPGSlalom.swift
//  Space Gravity
//
//  Created by John Champion on 4/30/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 A slalom object, where the ship is supposed to fly though the center without hitting the flags on either side.
 */
class SPGSlalom: SPGNode {
    
    /// Whether or not the ship has successfully flown through the slalom.
    var passed: Bool = false

    /**
    Properly instanciates a slalom object.
    - parameter position: The position in which the slalom gate is to spawn.
    - parameter angle: The angle which the slalom gate is to spawn, in radians.
    */
    init(withPosition position: CGPoint, angle: CGFloat, width: CGFloat) {
        super.init(texture: nil, color: .gray, size: CGSize(width: width, height: 20))
        self.zRotation = angle
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.name = "slalom"
        self.position = position
        self.color = .gray
        
        let left = SKShapeNode(circleOfRadius: 10)
        left.position = CGPoint(x: -1*self.size.width/2 + 10, y: 0)
        left.fillColor = .red
        left.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        left.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        left.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        left.physicsBody?.isDynamic = false
        
        let right = SKShapeNode(circleOfRadius: 10)
        right.position = CGPoint(x: self.size.width/2 - 10, y: 0)
        right.fillColor = .red
        right.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        right.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        right.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        right.physicsBody?.collisionBitMask = 0
        right.physicsBody?.affectedByGravity = false
        
        let checkpoint = SKShapeNode(circleOfRadius: 10)
        checkpoint.position = CGPoint(x: 0, y: 0)
        checkpoint.fillColor = .green
        checkpoint.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        checkpoint.physicsBody?.categoryBitMask = ContactCategory.slalom.rawValue
        checkpoint.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        checkpoint.physicsBody?.collisionBitMask = 0
        checkpoint.physicsBody?.affectedByGravity = false
        
        self.addChild(left)
        self.addChild(right)
        self.addChild(checkpoint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
