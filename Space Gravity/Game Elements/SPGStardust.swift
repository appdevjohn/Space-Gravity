//
//  SPGStardust.swift
//  Space Gravity
//
//  Created by John Champion on 4/30/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 A stardust piece, which has value and is collectable.
 */
class SPGStardust: SPGNode {
    
    /// The value of an instance of stardust.
    var worth: Int = 1
    
    /**
    Properly instanciates a stardust object.
    - parameter position: The position in which the stardust piece is to spawn.
    - parameter worth: The value of this instance of stardust.
    */
    init(withPosition position: CGPoint, worth: Int) {
        super.init(texture: nil, color: .yellow, size: CGSize(width: 25, height: 25))
        
        self.name = "stardust"
        self.position = position
        self.worth = worth
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.collectable.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    override func interact(_ context: Any?) {
        self.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
