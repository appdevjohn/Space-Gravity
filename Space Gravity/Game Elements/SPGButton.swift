//
//  SPGButton.swift
//  Space Gravity
//
//  Created by John Champion on 4/6/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class SPGButton: SKShapeNode {
    
    /// The label within the button.
    var buttonText = SKLabelNode()
    
    /// The image within the button
    var image = SKSpriteNode()
    
    init(withText text: String, size: CGSize, fontSize: CGFloat, nodeName name: String) {
        super.init()
        
        self.path = UIBezierPath(roundedRect: CGRect(x: -0.5*size.width, y: -0.5*size.height, width: size.width, height: size.height), cornerRadius: 0.2*size.height).cgPath
        self.fillColor = .white
        
        self.buttonText.text = text
        self.buttonText.fontName = "Montserrat-Medium"
        self.buttonText.fontSize = fontSize
        self.buttonText.fontColor = .black
        self.buttonText.horizontalAlignmentMode = .center
        self.buttonText.verticalAlignmentMode = .baseline
        self.buttonText.position = CGPoint(x: 0, y: -0.2*size.height)
        self.buttonText.adjustFontSize(toFitRect: self.frame)
        self.addChild(buttonText)
        
        self.name = name
    }
    
    init(withImageNamed imageName: String, size: CGSize, nodeName name: String) {
        super.init()
        
        self.path = UIBezierPath(roundedRect: CGRect(x: -0.5*size.width, y: -0.5*size.height, width: size.width, height: size.height), cornerRadius: size.height/2).cgPath
        self.fillColor = .white
        
        self.image = SKSpriteNode(imageNamed: imageName)
        self.image.size = CGSize(width: 0.8*self.frame.size.height, height: 0.8*self.frame.size.height)
        self.image.position = CGPoint.zero
        self.addChild(self.image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
