//
//  GameOverScene.swift
//  Space Gravity
//
//  Created by John Champion on 3/26/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    /// The score that was earned from the previously played game.
    var passedScore: Int = 0
    
    /// The label representing the score that was previously earned.
    var yourScore = SKLabelNode(text: "")
    
    // These strings are localized
    let playAgainText =     NSLocalizedString("Play Again", comment: "Text for the Play Again button.")
    let shareScoreText =    NSLocalizedString("Share Score", comment: "Text for the Share Score button.")
    let mainMenuText =      NSLocalizedString("Main Menu", comment: "Text for the Main Menu button.")
    let yourScoreText =     NSLocalizedString("Your Score", comment: "For label that displays the score that was just earned.")
    let highScoreText =     NSLocalizedString("High Score", comment: "For label that displays the high score.")
    let timesPlayedText =   NSLocalizedString("Times Played", comment: "For label that displays the number of times the game has been played.")
    let shareScoreMessage =   NSLocalizedString("share_score_message", comment: "The pre-written message that is to be shared with the score.")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = .black
        
        let topInset: CGFloat = (self.view?.safeAreaInsets.top.magnitude)!
        let bottomInset: CGFloat = (self.view?.safeAreaInsets.bottom.magnitude)!
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver.png")
        gameOver.scale(to: CGSize(width: 200, height: 125))
        gameOver.position = CGPoint(x: 0, y: (self.size.height/2 - topInset)/2 + 45)
        self.addChild(gameOver)
        
        self.yourScore.fontSize = 16
        self.yourScore.fontColor = .white
        self.yourScore.fontName = "Montserrat-Regular"
        self.yourScore.position = CGPoint(x: gameOver.position.x, y: gameOver.position.y - 100)
        
        let topScore = SKLabelNode(text: String.localizedStringWithFormat(highScoreText, SPGGameKitManager.shared.gameData["ClassicHighScore"] as! Int))
        topScore.fontSize = 16
        topScore.fontColor = .white
        topScore.fontName = "Montserrat-Regular"
        topScore.position = CGPoint(x: gameOver.position.x, y: gameOver.position.y - 130)
        
        let playAgainButton = SPGButton(withText: playAgainText, size: CGSize(width: 200, height: 50), fontSize: 20, nodeName: "classic")
        let shareButton = SPGButton(withText: shareScoreText, size: CGSize(width: 200, height: 50), fontSize: 20, nodeName: "share")
        let mainMenuButton = SPGButton(withText: mainMenuText, size: CGSize(width: 200, height: 50), fontSize: 20, nodeName: "main-menu")
        playAgainButton.position = CGPoint(x: 0, y: -25)
        shareButton.position = CGPoint(x: 0, y: -100)
        mainMenuButton.position = CGPoint(x: 0, y: -175)
        
        let timesPlayed = SKLabelNode(text: String.localizedStringWithFormat(timesPlayedText, SPGGameKitManager.shared.gameData["ClassicTimesPlayed"] as! Int))
        timesPlayed.position = CGPoint(x: 0, y: -0.5*self.size.height + bottomInset + 20)
        timesPlayed.fontSize = 14
        timesPlayed.fontColor = .white
        timesPlayed.fontName = "Montserrat-Regular"
        
        let background = SPGBackgroundLayer.generateStarsSprite(size: self.size, starCount: 60, isFront: true)
        background.position = CGPoint.zero
        
        self.addChild(self.yourScore)
        self.addChild(topScore)
        self.addChild(playAgainButton)
        self.addChild(shareButton)
        self.addChild(mainMenuButton)
        self.addChild(timesPlayed)
        self.addChild(background)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        for node in self.nodes(at: pos) {
            if node.name == "classic" {
                let transition = SKTransition.fade(withDuration: 0.25)
                let scene = ClassicModeScene(size: (self.view?.bounds.size)!)
                
                SPGSoundManager.shared.playButtonSound()
                
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "main-menu" {
                SPGGameKitManager.shared.saveGame(saveLocal: false)
                
                let transition = SKTransition.fade(withDuration: 0.25)
                let scene = MainMenuScene(size: (self.view?.bounds.size)!)
                
                SPGSoundManager.shared.playButtonSound()
                
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "share" {
                
                SPGSoundManager.shared.playButtonSound()
                
                let activityViewController = UIActivityViewController(activityItems: [String.localizedStringWithFormat(self.shareScoreMessage, self.passedScore)], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .markupAsPDF]
                self.view?.window?.rootViewController?.show(activityViewController, sender: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    /**
     Sets the 'Your Score' label.
     - parameter score: The score that was earned.
     */
    func setScore(score: Int) {
        self.passedScore = score
        self.yourScore.text = String.localizedStringWithFormat(yourScoreText, self.passedScore)
    }
}
