//
//  LevelFailedScene.swift
//  Space Gravity
//
//  Created by John Champion on 5/6/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class LevelFailedScene: SKScene {
    
    /// The level which was failed to trigger the presentation of this scene.
    var failedLevel: Int = 0

    // These strings are localized
    let playAgainText =     NSLocalizedString("Play Again", comment: "Text for the Play Again button.")
    let mainMenuText =      NSLocalizedString("Main Menu", comment: "Text for the Main Menu button.")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = .black
        
        let topInset: CGFloat = (self.view?.safeAreaInsets.top.magnitude)!
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver.png")
        gameOver.scale(to: CGSize(width: 200, height: 125))
        gameOver.position = CGPoint(x: 0, y: (self.size.height/2 - topInset)/2 + 45)
        self.addChild(gameOver)
        
        let playAgainButton = SPGButton(withText: playAgainText, size: CGSize(width: 200, height: 50), fontSize: 20, nodeName: "playAgainButton")
        let mainMenuButton = SPGButton(withText: mainMenuText, size: CGSize(width: 200, height: 50), fontSize: 20, nodeName: "mainMenuButton")
        playAgainButton.position = CGPoint(x: 0, y: -25)
        mainMenuButton.position = CGPoint(x: 0, y: -100)
        
        let background = SPGBackgroundLayer.generateStarsSprite(size: self.size, starCount: 60, isFront: true)
        background.position = CGPoint.zero
        
        self.addChild(playAgainButton)
        self.addChild(mainMenuButton)
        self.addChild(background)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        for node in self.nodes(at: pos) {
            if node.name == "playAgainButton" && self.failedLevel > 0 {
                if let scene = SKScene(fileNamed: "Level\(self.failedLevel)") {
                    if scene.userData == nil {
                        scene.userData = NSMutableDictionary()
                    }
                    scene.userData?.setValue(self.failedLevel, forKey: "level")
                    
                    let transition = SKTransition.fade(withDuration: 0.25)
                    
                    SPGSoundManager.shared.playButtonSound()
                    
                    self.view?.presentScene(scene, transition: transition)
                }
                
            } else if node.name == "mainMenuButton" {
                SPGGameKitManager.shared.saveGame(saveLocal: false)
                
                let transition = SKTransition.fade(withDuration: 0.25)
                let scene = MainMenuScene(size: (self.view?.bounds.size)!)
                
                SPGSoundManager.shared.playButtonSound()
                
                self.view?.presentScene(scene, transition: transition)
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
