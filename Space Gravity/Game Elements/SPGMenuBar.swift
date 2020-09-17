//
//  SPGMenuBar.swift
//  Space Gravity
//
//  Created by John Champion on 3/28/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class SPGMenuBar: SKShapeNode {
    
    /// The part of the menu bar that the status bar occupies.  Visible on devices with notches.
    var statusBar: SKSpriteNode!
    
    /// The part of the menu bar where game elements are displayed.
    var menuBar: SKSpriteNode!
    
    /// The label that displays the score in the menu bar.
    var scoreLabel: SKLabelNode!
    
    /// The progress bar that displays the amount of fuel of the ship.
    var fuelBar: SKSpriteNode!
    
    /**
     Properly instanciates a menu bar object.
     - parameter scene: The scene in which the menu bar will exist.
     */
    init(inScene scene: SKScene) {
        super.init()
        
        statusBar = SKSpriteNode(color: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), size: CGSize(width: scene.frame.width, height: scene.view?.safeAreaInsets.top ?? 0))
        menuBar = SKSpriteNode(color: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), size: CGSize(width: scene.frame.width, height: 55))
        
        self.scoreLabel = SKLabelNode(text: "0")
        
        self.fuelBar = SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: menuBar.size.width, height: 4))
        
        let pauseIcon = SKSpriteNode(imageNamed: "pause.png")
        
        statusBar.anchorPoint = CGPoint(x: 0, y: 1)
        statusBar.position =    CGPoint(x: 0, y: scene.frame.height)
        
        menuBar.anchorPoint =   CGPoint(x: 0, y: 1)
        menuBar.position =      CGPoint(x: 0, y: scene.frame.height - statusBar.size.height)
        
        self.scoreLabel.position = CGPoint(x: 16, y: -1*menuBar.size.height/2 - 8)
        self.scoreLabel.fontColor = .white
        self.scoreLabel.fontSize = 22
        self.scoreLabel.fontName = "Montserrat-Bold"
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.verticalAlignmentMode = .baseline
        
        self.fuelBar.anchorPoint = CGPoint(x: 0, y: 0)
        self.fuelBar.position = CGPoint(x: 0, y: -1*menuBar.size.height)
        
        pauseIcon.size = CGSize(width: 22, height: 28)
        pauseIcon.position = CGPoint(x: self.menuBar.size.width - 26, y: -0.5*(self.menuBar.size.height-self.fuelBar.size.height))
        
        self.zPosition = 3
        self.name = "menu-bar"
        
        self.addChild(statusBar)
        self.addChild(menuBar)
        menuBar.addChild(self.scoreLabel)
        menuBar.addChild(self.fuelBar)
        menuBar.addChild(pauseIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Sets up the text and placement for the instructions
    */
    class func setupInstructions(inNode node: SKSpriteNode, basePoint: CGPoint) {
        node.name = "instructions"
        
        // These strings are localized
        let instructionText1 =  NSLocalizedString("The ship flies toward your", comment: "First line of the instructions.")
        let instructionText2 =  NSLocalizedString("finger.  Watch your fuel.", comment: "Second line of the instructions.")
        let instructionText3 =  NSLocalizedString("Avoid the asteroids.", comment: "Third line of the instructions.")
        
        let instructionTextTop = SKLabelNode(text: instructionText1)
        let instructionTextMiddle = SKLabelNode(text: instructionText2)
        let instructionTextBottom = SKLabelNode(text: instructionText3)
        
        instructionTextTop.fontName = "Montserrat-Regular"
        instructionTextTop.fontSize = 20
        instructionTextTop.fontColor = .white
        instructionTextTop.horizontalAlignmentMode = .center
        instructionTextTop.position = CGPoint(x: basePoint.x, y: basePoint.y + 180)
        
        instructionTextMiddle.fontName = "Montserrat-Regular"
        instructionTextMiddle.fontSize = 20
        instructionTextMiddle.fontColor = .white
        instructionTextMiddle.horizontalAlignmentMode = .center
        instructionTextMiddle.position = CGPoint(x: instructionTextTop.position.x, y: instructionTextTop.position.y - 30)
        
        instructionTextBottom.fontName = "Montserrat-Regular"
        instructionTextBottom.fontSize = 20
        instructionTextBottom.fontColor = .white
        instructionTextBottom.horizontalAlignmentMode = .center
        instructionTextBottom.position = CGPoint(x: basePoint.x, y: basePoint.y - 180)
        
        node.addChild(instructionTextTop)
        node.addChild(instructionTextMiddle)
        node.addChild(instructionTextBottom)
    }
    
    func updateFuelAmount(toAmount amount: CGFloat, outOfFuel: Bool) {
        self.fuelBar.size = CGSize(width: amount*self.menuBar.size.width, height: self.fuelBar.size.height)
        
        self.fuelBar.color = outOfFuel ? UIColor.red : UIColor(red: 1-amount, green: 0, blue: amount, alpha: 1)
        
    }
}
