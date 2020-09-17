//
//  SPGDoor.swift
//  Space Gravity
//
//  Created by John Champion on 5/1/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 A door object. Door objects behaive very similarly to walls, with the only difference being that they can be opened and closed. This can only be done with switches whose channel is the same is this instance.
 */
class SPGDoor: SPGNode {

    /**
    Properly instanciates a door object.
    - parameter position: The position in which the door is to spawn.
    - parameter size: The size which the door is to spawn.
    - parameter size: The channel which is to be assigned to the door.
    */
    init(withPosition position: CGPoint, andSize size: CGSize, channel: Int) {
        super.init(texture: nil, color: .systemTeal, size: size)
        
        self.name = "door"
        self.channel = channel
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    /**
     Opens or closes the door.
     - parameter context: A boolean value, true if the door is open, false if the door is closed.
     */
    override func interact(_ context: Any?) {
        let status: Bool = context as! Bool
        status ? open() : close()
    }
    
    /**
     Opens the door.
     
     While the door is open, no contact or collisions can be detected with it because the category bit mask is set to zero.  The door will remain open indefinitely unless the closed function is called.
     */
    private func open() {
        self.physicsBody?.categoryBitMask = 0
        self.alpha = 0.2
    }
    
    /**
     Closes the door.
     */
    private func close() {
        self.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        self.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
