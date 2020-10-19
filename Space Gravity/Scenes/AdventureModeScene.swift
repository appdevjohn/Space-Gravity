//
//  AdventureModeScene.swift
//  Space Gravity
//
//  Created by John Champion on 3/28/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class AdventureModeScene: SKScene, SKPhysicsContactDelegate, SwitchDelegate {
    
    /// The menu bar at the top of the view.
    var menuBar: SPGMenuBar!
    
    /// The ship which is being controlled by the player.
    var ship: SPGShip!
    
    /// The goal to reach.
    var goal: SPGGoal?
    
    /// The amount of stardust the player has collected.
    var stardust: Int = 0
    
    /// The arrow that follows the ship and points in the direction of the goal.
    var pointer: SPGPointer!
    
    /// An array of nodes that are currently in contact with the ship.
    var touchingNodes: [SKNode] = []
    
    /// An array of doors in the scene.
    var doors: [SPGDoor] = []
    
    /// An array of aliens in the scene.
    var aliens: [SPGAlien] = []
    
    /// The parallax background.
    var background: SPGBackground!
    
    /// The point at which the player touches to make the ship move.
    var touchPoint = CGPoint.zero
    
    /// The level of the current scene.
    var level: Int = 0
    
    override func didMove(to view: SKView) {
        // Setting the properties of the scene
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = .black
        
        // Setting the level variable
        self.level = self.userData?["level"] as? Int ?? 0
        
        // Setting up the ship
        self.ship = SPGShip(withPosition: CGPoint(x: 0, y: 0))
        self.ship.zPosition = 2
        self.addChild(ship)
        
        // Setting up the camera
        let camera = SKCameraNode()
        camera.position = ship.position
        self.addChild(camera)
        self.camera = camera
        self.camera?.setScale(1.5)
        
        // Setting up the menu bar
        self.menuBar = SPGMenuBar(inScene: self)
        self.menuBar.position = CGPoint(x: self.ship.position.x - self.frame.width/2, y: self.ship.position.y - self.frame.height/2)
        self.camera!.addChild(menuBar)
        
        // Setting up the parallax background
        self.background = SPGBackground(inScene: self)
        self.camera?.addChild(self.background)
        
        // Setting up the pointer arrow
        self.pointer = SPGPointer()
        self.addChild(pointer)
        
        // The SpriteKit Editor is handy, but it's not perfect.  We can't add subclassed sprites in Xcode 11, so we have to add placeholder sprites in the scene.  When it loads, we're going to replace those sprites with the subclassed sprites.
        for node in self.children {
            if node.name == "asteroid" {
                let asteroid = SPGAsteroid()
                asteroid.position = node.position
                node.removeFromParent()
                self.addChild(asteroid)
                
            } else if node.name == "goal" {
                let goal = SPGGoal(withPosition: node.position)
                node.removeFromParent()
                self.goal = goal
                self.addChild(goal)
                
            } else if node.name == "wall" {
                let wall = SPGWall(withPosition: node.position, andSize: node.frame.size)
                node.removeFromParent()
                self.addChild(wall)
                
            } else if node.name == "switch" {
                let switchNode = SPGSwitch(withPosition: node.position, duration: TimeInterval(node.userData?["duration"] as! Int), channel: node.userData?["channel"] as? Int ?? 0)
                switchNode.delegate = self
                node.removeFromParent()
                self.addChild(switchNode)
                           
            } else if node.name == "stardust" {
                let stardust = SPGStardust(withPosition: node.position, worth: 1)
                node.removeFromParent()
                self.addChild(stardust)
                
            } else if node.name == "door" {
                let door = SPGDoor(withPosition: node.position, andSize: node.frame.size, channel: node.userData?["channel"] as? Int ?? 0)
                node.removeFromParent()
                self.addChild(door)
                self.doors.append(door)
                
            } else if node.name == "wormhole" {
                let wormhole = SPGWormhole(withPosition: node.position, id: node.userData?["id"] as? Int ?? 0, destinationID: node.userData?["destinationID"] as? Int ?? 0)
                node.removeFromParent()
                self.addChild(wormhole)
                
            } else if node.name == "slalom" {
                let slalom = SPGSlalom(withPosition: node.position, angle: node.zRotation, width: 100)
                node.removeFromParent()
                self.addChild(slalom)
                
            } else if node.name == "alien" {
                let alien = SPGAlien(withPosition: node.position, speed: node.userData?["speed"] as? CGFloat ?? 0)
                node.removeFromParent()
                self.addChild(alien)
                self.aliens.append(alien)
                
            } else if node.name == "comet" {
                let comet = SPGComet(withPosition: node.position, node.frame.size, TimeInterval(node.userData?["moveDuration"] as? Float ?? 1.0), TimeInterval(node.userData?["waitDuration"] as? Float ?? 1.0), node.userData?["movePositions"] as? String ?? "[]")
                node.removeFromParent()
                self.addChild(comet)
                comet.startMoving()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if self.ship.isHidden { return }
        
        // Defining some variables to make the rest of this function easier
        var interactNode: SKNode!
        if contact.bodyA.node!.name == "ship" {
            interactNode = contact.bodyB.node
        } else {
            interactNode = contact.bodyA.node
        }
        let interactNodeCategory = interactNode?.physicsBody?.categoryBitMask
        
        if !self.touchingNodes.contains(interactNode) {
            self.touchingNodes.append(interactNode)
        } else {
            return  // Already touching
        }
        
        if interactNodeCategory == ContactCategory.asteroid.rawValue {  // ASTEROID
            // Hide the ship so all the user sees is the explosion.
            self.ship.isHidden = true
            self.pointer.hidePointer(withDuration: 0.1)
            
            self.ship.physicsBody = nil
            
            // Explode, then move to the game over scene.
            let explosion = SPGExplosion(atPoint: self.ship.position)
            self.addChild(explosion)
            explosion.explode {
                let transition = SKTransition.fade(with: .white, duration: 0.7)
                let levelFailedScene = LevelFailedScene(size: (self.view?.bounds.size)!)
                levelFailedScene.failedLevel = self.level
                
                self.view?.presentScene(levelFailedScene, transition: transition)
            }
            
        } else if interactNodeCategory == ContactCategory.goal.rawValue {  // GOAL
            self.ship.isHidden = true
            
            self.ship.physicsBody = nil
            
            let transition = SKTransition.fade(with: .white, duration: 0.7)
            let nextScene = MainMenuScene(size: (self.view?.bounds.size)!)
            
            self.view?.presentScene(nextScene, transition: transition)
            
        } else if interactNodeCategory == ContactCategory.interactive.rawValue {  // SWITCH
            let switchNode: SPGSwitch = interactNode as! SPGSwitch
            switchNode.interact(nil)
            
        } else if interactNodeCategory == ContactCategory.collectable.rawValue {  // STARDUST
            let stardust: SPGStardust = interactNode as! SPGStardust
            self.stardust += stardust.worth
            stardust.interact(nil)
            
        } else if interactNodeCategory == ContactCategory.wormhole.rawValue {  // WORMHOLE
            let wormhole: SPGWormhole = interactNode as! SPGWormhole
            if wormhole.active {
                let destinationWormhole = findWormhole(withID: wormhole.destinationID)
                destinationWormhole?.active = false
                self.ship.isHidden = true
                self.ship.run(SKAction.move(to: destinationWormhole?.position ?? self.ship.position, duration: 0.1)) {
                    self.ship.isHidden = false
                }
            } else {
                wormhole.active = true
            }
            
        } else if interactNodeCategory == ContactCategory.slalom.rawValue {  // SLALOM
            let slalom: SPGSlalom = interactNode.parent as! SPGSlalom
            slalom.passed = true
        }
    }
    
    /**
     Finds a wormhole given an id.
     - parameter id: The id of the wormhole to find.
     */
    func findWormhole(withID id: Int) -> SPGWormhole? {
        for node in self.children {
            guard let wormhole = node as? SPGWormhole else { continue }
            if wormhole.id == id { return wormhole }
        }
        return nil
    }
    
    // Delegate function called when a switch has been activated.
    func switchActivated(switchNode: SPGSwitch) {
        switchNode.color = .yellow
        for door in self.doors {
            if door.channel == switchNode.channel {
                door.interact(true)
            }
        }
    }
    
    // Delegate function called when a switch has been deactivated.
    func switchDeactivated(switchNode: SPGSwitch) {
        switchNode.color = .blue
        for door in self.doors {
            if door.channel == switchNode.channel {
                door.interact(false)
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        touchPoint = pos
        ship.thrusting = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        touchPoint = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        ship.thrusting = false
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
        /*
         If the camera moves, but the player's finger doesn't,
         we will have to update touchPoint ourselves, since touchMoved won't be called.
         */
        
        // Notes the difference between touchPoint and the camera's position
        let touchOffset = CGPoint(x: self.touchPoint.x - self.camera!.position.x, y: self.touchPoint.y - self.camera!.position.y)
        
        // Updating the positions of the ship, camera, and menu bar
        self.ship.updateAcceleration(withPoint: self.touchPoint)
        self.menuBar.updateFuelAmount(toAmount: self.ship.fuel, outOfFuel: self.ship.outOfFuel)
        
        // Notes the difference between the position of the ship and camera.  This is to determine it's instantaneous velocity.
        let cameraOffset = CGPoint(x: ship.position.x - (camera?.position.x)!, y: ship.position.y - (camera?.position.y)!)
        
        // Moving the camera and menu bar, depending on where the ship is
        self.camera?.run(SKAction.move(to: self.ship.position, duration: 0))
        
        // The background performs the parallax effect.
        self.background.move(inVectorDirection: CGVector(dx: -1*cameraOffset.x, dy: -1*cameraOffset.y))
        
        // Modifies touchPoint to reflect the user's real touch intention
        self.touchPoint = CGPoint(x: self.touchPoint.x + touchOffset.x, y: self.touchPoint.y + touchOffset.y)
        
        // Adjust the pointer
        self.pointer.adjustPointer(shipPosition: self.ship.position, goalPosition: self.goal?.position ?? .zero)
        
        for alien in self.aliens {
            alien.followShip(shipPoint: self.ship.position)
        }
        
        // Removes nodes from touchingNodes array if the ship has moved away from them
        for (index, node) in self.touchingNodes.enumerated() {
            if !self.ship.intersects(node) {
                self.touchingNodes.remove(at: index)
            }
        }
    }
}
