//
//  SPGWormhole.swift
//  Space Gravity
//
//  Created by John Champion on 4/30/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 A wormhole object, which can be used to teleport the ship to a wormhole whose `id` is this instance's `destinationID`
 */
class SPGWormhole: SPGNode {
    
    /// The id of the wormhole which this instance links to.
    var destinationID: Int = 0
    
    /// Whether or not the wormhole is functional.  This should be set to false if this instance becomes a destination so the ship doesn't travel back though the destination wormhole to where they started.
    var active: Bool = true
    
    /**
    Properly instanciates a wormhole object.
    - parameter position: The position in which the wormhole is to spawn.
    - parameter id: The id of the wormhole.  This must be unique.
    - parameter destinationID: The id of the wormhole which this instance links to.
    */
    init(withPosition position: CGPoint, id: Int, destinationID: Int) {
        super.init(texture: nil, color: .gray, size: CGSize(width: 50, height: 50))
        
        self.name = "wormhole"
        self.position = position
        self.id = id
        self.destinationID = destinationID
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.wormhole.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
