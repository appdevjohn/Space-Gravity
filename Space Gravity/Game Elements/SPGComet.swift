//
//  SPGComet.swift
//  Space Gravity
//
//  Created by John Champion on 10/12/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 Comet objects endlessly move to a series of points within the level.
 */
class SPGComet: SPGNode {
    
    /// Boolean value indicating whether or not the comet is on its move cycle.
    var active: Bool = false
    
    /// The duration which the comet will take to move to the next point.
    var moveDuration: TimeInterval = 1
    
    /// The duration for which the comet will stay at each point.
    var waitDuration: TimeInterval = 1
    
    /// The array of positions which the comet will move between.
    var movePositions: [CGPoint] = [];
    
    /// The index of the current position of the movePositions array.
    var movePositionIndex: Int = 0
    
    /// A struct used to parse position data from the Scene Editor.
    struct CometPosition: Decodable {
        let x: CGFloat
        let y: CGFloat
    }
    
    /**
     Properly instanciates a comet object.
     - parameter position: The initial position which the comet should spawn.
     - parameter size: This size of the comet.
     - parameter moveDuration: The time it should take for the comet to move from one position to the next.
     - parameter waitDuration: The amount of time the comet should wait at each position before moving to the next.
     - parameter moveSpots: An array  of positions which the comet is to move.
     */
    init(withPosition position: CGPoint, _ size: CGSize, _ moveDuration: TimeInterval, _ waitDuration: TimeInterval, _ movePositions: [CGPoint]) {
        
        super.init(texture: nil, color: .systemTeal, size: size)
        self.initCometObject(withPosition: position, size, moveDuration, waitDuration, movePositions)
    }
    
    /**
     Properly instanciates a comet object.
     - parameter position: The initial position which the comet should spawn.
     - parameter size: This size of the comet.
     - parameter moveDuration: The time it should take for the comet to move from one position to the next.
     - parameter waitDuration: The amount of time the comet should wait at each position before moving to the next.
     - parameter moveSpots: A JSON string containing an array of positions which the comet is to move.
     */
    init(withPosition position: CGPoint, _ size: CGSize, _ moveDuration: TimeInterval, _ waitDuration: TimeInterval, _ movePositions: String) {
        
        super.init(texture: nil, color: .systemTeal, size: size)
        
        var cometPositions: [CGPoint] = []  // Array of positions that will be used to initialize comet.
        do {
            // Parsing the JSON string into usable data for the comet positions.
            let moveSpotsData = Data(movePositions.utf8)
            let parsedMovePositions = try JSONDecoder().decode([CometPosition].self, from: moveSpotsData)
            
            // Populating array of positions with data.
            for spot in parsedMovePositions {
                cometPositions.append(CGPoint(x: spot.x, y: spot.y))
            }
        } catch {
            print("An error occured parsing the positions for a comet. \(error.localizedDescription)")
        }
        
        self.initCometObject(withPosition: position, size, moveDuration, waitDuration, cometPositions)
    }
    
    /**
     Properly sets up a comet object.
     - parameter position: The initial position which the comet should spawn.
     - parameter size: This size of the comet.
     - parameter moveDuration: The time it should take for the comet to move from one position to the next.
     - parameter waitDuration: The amount of time the comet should wait at each position before moving to the next.
     - parameter moveSpots: An array  of positions which the comet is to move.
     */
    private func initCometObject(withPosition position: CGPoint, _ size: CGSize, _ moveDuration: TimeInterval, _ waitDuration: TimeInterval, _ moveSpots: [CGPoint]) {
        
        self.name = "comet"
        self.position = position
        self.moveDuration = moveDuration
        self.waitDuration = waitDuration
        self.movePositions = moveSpots;
        self.movePositions.insert(position, at: 0)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.asteroid.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    func startMoving() {
        self.active = true
        
        Timer.scheduledTimer(withTimeInterval: self.moveDuration + self.waitDuration, repeats: true) { (timer) in
            self.moveComet()
        }
    }
    
    private func moveComet() {
        movePositionIndex += 1
        if movePositionIndex >= movePositions.count {
            movePositionIndex = 0
        }
        
        let nextPosition = movePositions[movePositionIndex]
        let moveAction = SKAction.move(to: nextPosition, duration: self.moveDuration)
        moveAction.timingMode = .easeInEaseOut
        
        self.run(moveAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
