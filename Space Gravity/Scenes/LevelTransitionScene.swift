//
//  LevelTransitionScene.swift
//  Space Gravity
//
//  Created by John Champion on 5/6/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 This kind of scene is used to transition between levels in a way that allows for a deeper experience.
 */
class LevelTransitionScene: SKScene {
    
    /// The level of the scene that will be presented
    private var level: Int = 0
    
    /**
     Properly instanciates a level transition scene.
     - parameter size: The size which the scene will be displayed.
     - parameter level: The level which the scene will transition to.
     */
    init(withSize size: CGSize, level: Int) {
        super.init(size: size)
        self.level = level
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .black
        
        // Define variable to contain transition message.
        var transitionMessage: String = "Challenge Incoming..."
        
        // Get the transition message associated with the level from the TransitionMessages.plist file.
        getPath: if let path = Bundle.main.path(forResource: "TransitionMessages", ofType: "plist") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! [String: String]
                transitionMessage = plist["\(self.level)"] ?? "Challenge Incoming..."
            } catch {
                break getPath
            }
        }
        
        // Set the background
        let background = SPGBackground(inScene: self)
        self.addChild(background)
        
        // Create the label
        let label = SKLabelNode(text: transitionMessage)
        label.fontSize = 24
        label.fontColor = .white
        label.fontName = "Montserrat-Bold"
        label.position = .zero
        label.alpha = 0
        label.adjustFontSize(toFitRect: self.frame)
        self.addChild(label)
        
        // Animate the label, and transition when
        label.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 1),
            SKAction.wait(forDuration: 1),
            SKAction.fadeOut(withDuration: 1),
            SKAction.run({
                if let scene = SKScene(fileNamed: "Level\(self.level)") {
                    if scene.userData == nil {
                        scene.userData = NSMutableDictionary()
                    }
                    scene.userData?.setValue(self.level, forKey: "level")
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                } else {
//                    let transition = SKTransition.fade(withDuration: 0.25)
//                    let scene = MainMenuScene(size: (self.view?.bounds.size)!)
//                    self.view?.presentScene(scene, transition: transition)
                    
                    // The code above is temporarily commeted out. The code below will launch the test level.
                    let scene = SKScene(fileNamed: "TestLevel")
                    if scene!.userData == nil {
                        scene!.userData = NSMutableDictionary()
                    }
                    scene!.userData?.setValue(self.level, forKey: "level")
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene!, transition: transition)
                }
            })
        ]))
    }
}
