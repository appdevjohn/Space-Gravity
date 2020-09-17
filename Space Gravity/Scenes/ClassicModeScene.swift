//
//  ClassicModeScene.swift
//  Space Gravity
//
//  Created by John Champion on 3/25/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit
import GameKit
import AVFoundation

class ClassicModeScene: SKScene, SKPhysicsContactDelegate {
    
    /// The menu bar at the top of the view
    var menuBar: SPGMenuBar!
    
    /// The Ship which is being controlled by the player
    var ship: SPGShip!
    
    /// The array of asteroids spawned into the game
    var asteroids: [SPGAsteroid] = []
    
    /// The sprite containing the instructions for the game
    let instructions = SKSpriteNode()
    
    /// The point at which the player touches to make the ship move.
    var touchPoint = CGPoint.zero
    
    /// The current score
    var score: Int = 0
    
    /// Whether or not the game has started.
    var gameStarted = false
    
    /// The label that appears when the game is paused.
    var pauseLabel = SKLabelNode(text: NSLocalizedString("PAUSED", comment: "The text that appears in the middle of the screen when the game is paused."))
    
    /// The actual value of pause
    var realPaused = false
    {
       didSet {
           isPaused = realPaused
       }
    }
    
    // This is SpriteKit's own pause variable.  Since it automatically sets itself to false every time the app comes back to the foreground, which we can't have, we can't use it as it was made.
    override var isPaused : Bool {
        get {
            return realPaused
        } set {
            if realPaused != newValue {
                self.isPaused = realPaused
            }
        }
    }

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = .black
        
        let background = SPGBackgroundLayer.generateStarsSprite(size: self.size, starCount: 60, isFront: true)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        self.menuBar = SPGMenuBar(inScene: self)
        self.addChild(menuBar)
        
        self.ship = SPGShip(withPosition: CGPoint(x: self.size.width/2, y: self.size.height/2))
        self.addChild(ship)
        
        SPGMenuBar.setupInstructions(inNode: self.instructions, basePoint: self.ship.position)
        self.addChild(self.instructions)
        
        self.pauseLabel.fontName = "Montserrat-Bold"
        self.pauseLabel.fontSize = 32
        self.pauseLabel.fontColor = .white
        self.pauseLabel.zPosition = 3
        self.pauseLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.pauseLabel.isHidden = true
        self.addChild(self.pauseLabel)
    }
    
    /**
     The scene will remove the instructions, spawn the asteroids, and start keeping score.
     */
    private func startGame() {
        self.gameStarted = true
        self.realPaused = false
        
        self.instructions.removeFromParent()
        
        // Asteroid spawning is staggered so the player isn't overwhelmed in the first second
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (t) in
            if self.asteroids.count >= 5 { t.invalidate() }

            let asteroid = SPGAsteroid()
            self.asteroids.append(asteroid)
            self.addChild(asteroid)
            asteroid.initiateFlyBy()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if self.ship.isHidden { return }
        SPGGameKitManager.shared.saveClassicModeHighScore(score: self.score)
        SPGGameKitManager.shared.incrementTimesPlayed()
        
        self.ship.physicsBody = nil
        
        // Hide the ship so all the user sees is the explosion.
        self.ship.isHidden = true
        
        // Explode, then move to the game over scene.
        let explosion = SPGExplosion(atPoint: self.ship.position)
        self.addChild(explosion)
        explosion.explode {
            let transition = SKTransition.fade(with: .white, duration: 0.7)
            let gameOverScene = GameOverScene(size: (self.view?.bounds.size)!)
            gameOverScene.setScore(score: self.score)
            
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if !gameStarted { self.startGame() }
        
        for node in nodes(at: pos) {
            if node.name == "menu-bar" {
                if self.realPaused {
                    SPGSoundManager.shared.playPauseSound()
                    self.realPaused = false
                    self.pauseLabel.isHidden = true
                } else {
                    SPGSoundManager.shared.playPauseSound()
                    self.realPaused = true
                    self.pauseLabel.isHidden = false
                }
                return
            }
        }
        
        self.touchPoint = pos
        self.ship.thrusting = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.touchPoint = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.ship.thrusting = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !self.gameStarted { return }
        
        self.ship.updateAcceleration(withPoint: self.touchPoint)
        
        if self.ship.position.x < -20 {
            self.ship.run(SKAction.moveBy(x: self.size.width+40, y: 0, duration: 0))
        } else if self.ship.position.x > self.size.width+20 {
            self.ship.run(SKAction.moveBy(x: -1*self.size.width-40, y: 0, duration: 0))
        }
        if self.ship.position.y < -20 {
            self.ship.run(SKAction.moveBy(x: 0, y: self.size.height+40, duration: 0))
        } else if self.ship.position.y > self.size.height+20 {
            self.ship.run(SKAction.moveBy(x: 0, y: -1*self.size.height-40, duration: 0))
        }
        
        for asteroid in self.asteroids {
            asteroid.run(SKAction.move(by: asteroid.velocity, duration: 0))
            
            // If the asteroid is flying out of bounds, it will be reset
            if (asteroid.position.x < -50 && asteroid.velocity.dx < 0) ||
                (asteroid.position.x > self.size.width + 50 && asteroid.velocity.dx > 0) ||
                (asteroid.position.y < -50 && asteroid.velocity.dy < 0) ||
                (asteroid.position.y > self.size.height + 50 && asteroid.velocity.dy > 0) {
                
                asteroid.initiateFlyBy()
            }
        }
        
        // If this ship is hidden, the explosion animation was shown, and we need to stop incrementing score.
        if !self.ship.isHidden {
            self.menuBar.updateFuelAmount(toAmount: self.ship.fuel, outOfFuel: self.ship.outOfFuel)
            
            self.score += 1
            self.menuBar.scoreLabel.text = "\(self.score)"
        }
    }
}
