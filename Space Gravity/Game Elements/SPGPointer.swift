//
//  SPGPointer.swift
//  Space Gravity
//
//  Created by John Champion on 4/29/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 An arrow that follows the ship and points in the direction of the goal.
 
 An instance of this class should be added to the scene, not the ship.
 */
class SPGPointer: SPGNode {
    
    /**
    Properly instanciates a pointer object.
    */
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 140, height: 140))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.name = "pointer"
        
        let shape = SKShapeNode(circleOfRadius: 10)
        shape.fillColor = .black
        shape.strokeColor = .white
        shape.lineWidth = 3
        shape.position = CGPoint(x: 0, y: self.size.height/2)
        shape.zPosition = 3
        shape.alpha = 0.4
        self.addChild(shape)
        
        shape.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0.2, duration: 1),
                                                            SKAction.fadeAlpha(to: 0.4, duration: 1)])))
    }
    
    /**
     Adjusts the position and rotation of the pointer
     - parameter shipPosition: The position of the ship in the scene.
     - parameter goalPosition: The position of the goal in the scene.
     */
    func adjustPointer(shipPosition: CGPoint, goalPosition: CGPoint) {
        self.position = shipPosition  // Centering pointer on ship position
        
        // Pathagorean theorem
        let xLeg = shipPosition.x - goalPosition.x
        let yLeg = shipPosition.y - goalPosition.y
        let hypotenuse = sqrt(pow(xLeg, 2) + pow(yLeg, 2))
        
        // Rotating the pointer
        var radians = atan(yLeg/xLeg) - 3.14159/2
        if goalPosition.x < shipPosition.x {
            radians = radians + 3.14159
        } else if goalPosition.x == shipPosition.x && goalPosition.y < shipPosition.y {  // Special case
            radians = -3.14159
        }
        self.run(SKAction.rotate(toAngle: radians, duration: 0))
        
        if hypotenuse < 200 {
            self.hidePointer(withDuration: 0.1)
        } else {
            self.showPointer(withDuration: 0.1)
        }
    }
    
    /**
     Makes the pointer appear using a fade transition.
     - parameter duration: The duration which the fade transition lasts.
     */
    func showPointer(withDuration duration: TimeInterval?) {
        self.run(SKAction.fadeIn(withDuration: duration ?? 0.1))
    }
    
    /**
    Makes the pointer disappear using a fade transition.
    - parameter duration: The duration which the fade transition lasts.
    */
    func hidePointer(withDuration duration: TimeInterval?) {
        self.run(SKAction.fadeOut(withDuration: duration ?? 0.1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
