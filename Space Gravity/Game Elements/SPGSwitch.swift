//
//  SPGSwitch.swift
//  Space Gravity
//
//  Created by John Champion on 4/30/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

/**
 A switch, which when hit, is activated.
 
 Activated switches are meant to be open ended. They can interact when other instances on their own, as long as those instances are on the same channel as this instance.  Once switches are activated, they become deactivated until a certain amount of time, as specified in the constructor.
 */
class SPGSwitch: SPGNode {
    
    /// Boolean value indicating whether or not the switch is active.
    var active: Bool = false
    
    /// The duration for which the switch will stay activated.
    var duration: TimeInterval = 1
    
    /// The controller responsible for receiving callbacks.
    weak var delegate: SwitchDelegate?
    
    /**
    Properly instanciates a switch object.
    - parameter position: The position in which the switch is to spawn.
    - parameter duration: The duration which the switch will stay activated before deactivating.
    - parameter channel: The channel which the switch will activate elements in the scene.
    */
    init(withPosition position: CGPoint, duration: TimeInterval, channel: Int) {
        super.init(texture: nil, color: .blue, size: CGSize(width: 40, height: 40))
        
        self.name = "switch"
        self.position = position
        self.duration = duration
        self.channel = channel
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = ContactCategory.interactive.rawValue
        self.physicsBody?.contactTestBitMask = ContactCategory.ship.rawValue
        self.physicsBody?.isDynamic = false
    }
    
    /**
     Called when the switch is activated.
     */
    override func interact(_ context: Any?) {
        if !self.active {
            self.activate()
            Timer.scheduledTimer(withTimeInterval: self.duration, repeats: false) { (timer) in
                self.deactivate()
            }
        }
    }
    
    private func activate() {
        self.active = true
        self.delegate?.switchActivated(switchNode: self)
    }
    
    private func deactivate() {
        self.active = false
        self.delegate?.switchDeactivated(switchNode: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**
 These delegate functions are called to notify the scene that the switch is doing something.
 */
protocol SwitchDelegate: AnyObject {
    
    /**
     Called when the switch has been activated.
     - parameter switch: The switch that has been activated.
     */
    func switchActivated(switchNode: SPGSwitch)
    
    /**
    Called when the switch has been deactivated.
    - parameter switch: The switch that has been deactivated.
    */
    func switchDeactivated(switchNode: SPGSwitch)
}
