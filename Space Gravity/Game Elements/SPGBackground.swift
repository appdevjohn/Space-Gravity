//
//  SPGBackground.swift
//  Space Gravity
//
//  Created by John Champion on 3/29/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

enum Direction {
    case up
    case down
    case left
    case right
}

/*
 To produce the parallax effect, an instance of this class will need to
 be added as a child to the camera node.  Within a SPGBackground object
 there are multiple layers that will move at different rates.  Each layer
 has four child SKSpriteNodes that will wrap as needed.
 */

class SPGBackground: SKSpriteNode {
    
    // Layers of the background
    var backgroundTop: SPGBackgroundLayer!
    var backgroundBottom: SPGBackgroundLayer!
    
    /**
     Properly instanciates a background layer object.
     - parameter scene: The scene in which the background will be displayed.
     */
    convenience init(inScene scene: SKScene) {
        self.init(texture: nil, color: .clear, size: scene.size)
        self.zPosition = 0
        
        self.backgroundTop = SPGBackgroundLayer(inScene: scene, rate: 0.1, isFront: true)
        self.backgroundBottom = SPGBackgroundLayer(inScene: scene, rate: 0.06, isFront: false)
        
        self.addChild(self.backgroundTop)
        self.addChild(self.backgroundBottom)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Animates the background properly to produce the parallax affect.
     - parameter vector: The vector which the background shuld move in relation to the camera.
     */
    func move(inVectorDirection vector: CGVector) {
        self.backgroundTop.move(inVectorDirection: vector)
        self.backgroundBottom.move(inVectorDirection: vector)
    }
}


class SPGBackgroundLayer: SKSpriteNode {
    
    // These are pieces of background, meant to be pieced together.
    private var topLeft: SKSpriteNode!
    private var topRight: SKSpriteNode!
    private var bottomLeft: SKSpriteNode!
    private var bottomRight: SKSpriteNode!
    
    /// The rate of movement of the layer in relation to the velocity of the camera.  Zero by default.
    var rate: CGFloat = 0
    
    /**
     Properly instanciates a background layer object.
     - parameter scene: The scene in which the background will be displayed.
     - parameter rate: The rate at which the layer should move in relation to the camera.
     - parameter isFront: Specifies whether or not the layer is the front layer.  If true, the stars may appear larger.
     */
    convenience init(inScene scene: SKScene, rate: CGFloat, isFront: Bool) {
        self.init(texture: nil, color: .clear, size: CGSize(width: scene.size.width*2, height: scene.size.height*2))
        
        self.rate = rate
        
        self.topLeft = SPGBackgroundLayer.generateStarsSprite(size: scene.size, starCount: 30, isFront: isFront)
        self.topRight = SPGBackgroundLayer.generateStarsSprite(size: scene.size, starCount: 30, isFront: isFront)
        self.bottomLeft = SPGBackgroundLayer.generateStarsSprite(size: scene.size, starCount: 30, isFront: isFront)
        self.bottomRight = SPGBackgroundLayer.generateStarsSprite(size: scene.size, starCount: 30, isFront: isFront)
        
        self.topLeft.position = CGPoint(x: 0 - topLeft.size.width/2, y: topLeft.size.height/2)
        self.topRight.position = CGPoint(x: topLeft.size.width/2, y: topLeft.size.height/2)
        self.bottomLeft.position = CGPoint(x: 0 - topLeft.size.width/2, y: 0 - topLeft.size.height/2)
        self.bottomRight.position = CGPoint(x: topLeft.size.width/2, y: 0 - topLeft.size.height/2 )

        self.addChild(topLeft)
        self.addChild(topRight)
        self.addChild(bottomLeft)
        self.addChild(bottomRight)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Generates a piece of the background
     - parameter size: The size of the piece of background; must be equal to the size of the displaying view.
     - parameter starCount: the number of stars in the piece
     - parameter largeStars: If true, stars of varying sizes will spawn.  Else, the star sizes will remain at radius 1.
     - returns: An SKSpriteNode representing a piece of the background
     */
    class func generateStarsSprite(size: CGSize, starCount: Int, isFront: Bool) -> SKSpriteNode {
        let sprite = SKSpriteNode(texture: nil, color: .clear, size: size)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        for _ in 0...starCount-1 {
            let starRadius: CGFloat = (isFront ? [1, 1, 1, 1, 1, 1, 2, 2, 3].randomElement() : 1)!
            let star = SKShapeNode(rectOf: CGSize(width: starRadius, height: starRadius))
            star.fillColor = isFront ? .white : .lightGray
            star.lineWidth = 0
            star.position = CGPoint(
                x: CGFloat.random(in: -0.5*size.width...size.width/2),
                y: CGFloat.random(in: -0.5*size.height...size.height/2)
            )
            sprite.addChild(star)
        }

        return sprite
    }
    
    /**
     Handles the complicated task of moving the background to create a parallax effect with a moving camera.
     - parameter vector: The vector direction that the background should move
     */
    func move(inVectorDirection vector: CGVector) {
        if self.parent == nil { return }  // Must be attached to camera

        // Move the layers here at their appropriate pace
        self.run(SKAction.move(by: CGVector(dx: self.rate*vector.dx, dy: self.rate*vector.dy), duration: 0))

        // Wraps the pieces of the layer if they move out of view
        if self.position.x < -1*self.size.width/4 {
            self.wrapfrontLayer(inDirection: .right)
        } else if self.position.x > self.size.width/4 {
            self.wrapfrontLayer(inDirection: .left)
        }
        if self.position.y < -1*self.size.height/4 {
            self.wrapfrontLayer(inDirection: .up)
        } else if self.position.y > self.size.height/4 {
            self.wrapfrontLayer(inDirection: .down)
        }
    }
    
    /**
     Handles the wrapping of the background nodes.
     - parameter direction: An emun of Direction type that specifies which direction the nodes should wrap.
     - bug: If the layer is moving too quckly, it becomes visible that the layer is wrapping.
     - note: Wrapping works by doing three different things.  First, the positions of both sides of the layer are swapped.
     Second, the reference values of those objects are swapped.  Last, the entire layer is moved.
     */
    private func wrapfrontLayer(inDirection direction: Direction) {
        switch direction {
            case .up:
                bottomLeft.run(SKAction.moveTo(y: self.topLeft.size.height/2, duration: 0))
                bottomRight.run(SKAction.moveTo(y: self.topRight.size.height/2, duration: 0))
                topLeft.run(SKAction.moveTo(y: -1*self.bottomLeft.size.height/2, duration: 0))
                topRight.run(SKAction.moveTo(y: -1*self.bottomLeft.size.height/2, duration: 0))
                
                let tl = topLeft
                let tr = topRight
                let bl = bottomLeft
                let br = bottomRight
                
                topLeft = bl
                topRight = br
                bottomLeft = tl
                bottomRight = tr
                
                self.run(SKAction.moveTo(y: self.topRight.size.height/2, duration: 0))
            
            case .down:
                bottomLeft.run(SKAction.moveTo(y: self.topLeft.size.height/2, duration: 0))
                bottomRight.run(SKAction.moveTo(y: self.topRight.size.height/2, duration: 0))
                topLeft.run(SKAction.moveTo(y: -1*self.bottomLeft.size.height/2, duration: 0))
                topRight.run(SKAction.moveTo(y: -1*self.bottomLeft.size.height/2, duration: 0))
                
                let tl = topLeft
                let tr = topRight
                let bl = bottomLeft
                let br = bottomRight
                
                topLeft = bl
                topRight = br
                bottomLeft = tl
                bottomRight = tr
                
                self.run(SKAction.moveTo(y: -1*self.bottomLeft.size.height/2, duration: 0))
            
            case .left:
                topRight.run(SKAction.moveTo(x: -1*self.topLeft.size.width/2, duration: 0))
                bottomRight.run(SKAction.moveTo(x: -1*self.topLeft.size.width/2, duration: 0))
                topLeft.run(SKAction.moveTo(x: self.topLeft.size.width/2, duration: 0))
                bottomLeft.run(SKAction.moveTo(x: self.topLeft.size.width/2, duration: 0))
                
                let tl = topLeft
                let tr = topRight
                let bl = bottomLeft
                let br = bottomRight
                
                topLeft = tr
                topRight = tl
                bottomLeft = br
                bottomRight = bl
                
                self.run(SKAction.moveTo(x: -1*self.topLeft.size.width/2, duration: 0))
            
            case .right:
                topRight.run(SKAction.moveTo(x: -1*self.topLeft.size.width/2, duration: 0))
                bottomRight.run(SKAction.moveTo(x: -1*self.topLeft.size.width/2, duration: 0))
                topLeft.run(SKAction.moveTo(x: self.topLeft.size.width/2, duration: 0))
                bottomLeft.run(SKAction.moveTo(x: self.topLeft.size.width/2, duration: 0))
                
                let tl = topLeft
                let tr = topRight
                let bl = bottomLeft
                let br = bottomRight
                
                topLeft = tr
                topRight = tl
                bottomLeft = br
                bottomRight = bl
                
                self.run(SKAction.moveTo(x: self.topLeft.size.width/2, duration: 0))
        }
    }
}
