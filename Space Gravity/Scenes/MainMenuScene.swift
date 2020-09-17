//
//  MainMenuScene.swift
//  Space Gravity
//
//  Created by John Champion on 3/26/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenuScene: SKScene {
    
    /// The parallax background of the main menu.
    var background: SPGBackground!
    
    // These strings are localized
    let playClassicButtonText =     NSLocalizedString("Classic", comment: "The play button on the main menu.")
    let playAdventureButtonText =   NSLocalizedString("Adventure", comment: "The button that links to adventure mode on the main menu.")
    let scoreButtonText =           NSLocalizedString("Scores", comment: "The button that shows the leaderboard.")
    let soundOnText =               NSLocalizedString("Sound On", comment: "The button toggled to say Sound On.")
    let soundOffText =              NSLocalizedString("Sound Off", comment: "The button toggled to say Sound Off.")
    
    override func didMove(to view: SKView) {
        // Setting sceen properties
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .black
        let topInset: CGFloat = (self.view?.safeAreaInsets.top.magnitude)!
        
        // Setting up the title
        let title = SKSpriteNode(imageNamed: "title.png")
        title.scale(to: CGSize(width: 250, height: 156))
        title.position = CGPoint(x: 0, y: (self.size.height/2 - topInset)/2)
        
        // Setting up the buttons
        let playClassicButton =     SPGButton(withText: playClassicButtonText,
                                              size: CGSize(width: 225, height: 50),
                                              fontSize: 24,
                                              nodeName: "classic")
        let playAdventureButton =           SPGButton(withText: playAdventureButtonText,
                                              size: CGSize(width: 225, height: 50),
                                              fontSize: 24,
                                              nodeName: "adventure")
        let viewLeaderboardButton = SPGButton(withText: scoreButtonText,
                                              size: CGSize(width: 150, height: 40),
                                              fontSize: 18,
                                              nodeName: "leaderboard")
        let muteButton =            SPGButton(withText: soundOnText,
                                              size: CGSize(width: 150, height: 40),
                                              fontSize: 18,
                                              nodeName: "mute")
        
        // Positioning the buttons
        playClassicButton.position =        CGPoint(x: 0, y: -0)
        playAdventureButton.position =      CGPoint(x: 0, y: -65)
        viewLeaderboardButton.position =    CGPoint(x: 0, y: -145)
        muteButton.position =               CGPoint(x: 0, y: -200)
        
        // Setting the correct zPosition for the buttons
        playClassicButton.zPosition =       1
        playAdventureButton.zPosition =     1
        viewLeaderboardButton.zPosition =   1
        muteButton.zPosition =              1
        
        // Setting the correct state of the mute switch
        if SPGSoundManager.shared.getMute() {
            muteButton.buttonText.text = soundOffText
        } else {
            muteButton.buttonText.text = soundOnText
        }
        
        // Setting up the parallax background
        self.background = SPGBackground(inScene: self)
        
        // Adding all nodes to the scene
        self.addChild(self.background)
        self.addChild(title)
        self.addChild(playClassicButton)
        self.addChild(playAdventureButton)
        self.addChild(viewLeaderboardButton)
        self.addChild(muteButton)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        for node in self.nodes(at: pos) {
            if node.name == "classic" {
                let transition = SKTransition.fade(withDuration: 0.25)
                let scene = ClassicModeScene(size: (self.view?.bounds.size)!)
                
                SPGSoundManager.shared.playButtonSound()
                
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "adventure" {
                let scene = LevelPickerScene(size: (self.view?.bounds.size)!)
                let transition = SKTransition.fade(withDuration: 0.25)
                
                SPGSoundManager.shared.playButtonSound()
                           
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "leaderboard" {
                SPGGameKitManager.shared.showGameCenterViewController(inScene: self)
                
                SPGSoundManager.shared.playButtonSound()
                
            } else if node.name == "mute" {
                let muteButton = node as! SPGButton
                
                SPGSoundManager.shared.setMute(muted: !SPGSoundManager.shared.getMute())
                
                if SPGSoundManager.shared.getMute() {
                    muteButton.buttonText.text = self.soundOffText
                } else {
                    muteButton.buttonText.text = self.soundOnText
                    SPGSoundManager.shared.playButtonSound()
                }
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.background.move(inVectorDirection: CGVector(dx: 2, dy: 2))
    }
}
