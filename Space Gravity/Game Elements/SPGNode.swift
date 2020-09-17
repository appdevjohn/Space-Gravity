//
//  SPGNode.swift
//  Space Gravity
//
//  Created by John Champion on 5/3/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 This is meant to be the parent class of any game object.  It contains properties that allow it to smoothly interact with the rest of the scene.
 */
class SPGNode: SKSpriteNode {
    
    /// A unique id assigned to this node in the scene.
    var id: Int = 0
    
    /// A value assigned to this node that allows messages to be recieved by senders sending to a certain channel.
    var channel: Int = 0
    
    /**
     Allows for interaction with this node.  It's here in case child classes want to use it.
     - parameter context: Data necessary for the instance to interact.
     */
    func interact(_ context: Any?) {
        
    }
}


extension SKLabelNode {
    /**
     Adjusts the font size of a label to fit perfectly inside a node, given a CGRect.
     - parameter label: The label whose font should be resized.
     - parameter rect: The rect of the node which the label should be made to fit in.
     */
    func adjustFontSize(toFitRect rect: CGRect) {
        // Return if the label already fits.
        if self.frame.width <= rect.width { return }
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / self.frame.width, rect.height / self.frame.height)
        
        // Change the fontSize.
        self.fontSize *= scalingFactor
    }
}
