//
//  LevelPickerScene.swift
//  Space Gravity
//
//  Created by John Champion on 5/6/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import SpriteKit

class LevelPickerScene: SKScene {
    
    /// The current page of levels that are being displayed.  The first page starts at 0.
    private var page: Int = 0
    
    /// Boolean value representing whether or not the view is animating transitions between pages.
    private var animating: Bool = false

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .black
        
        // Setting up a grid of buttons to link to levels.
        let levelButtons = SKSpriteNode(color: .clear, size: CGSize(width: 300, height: 400))
        levelButtons.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        levelButtons.position = .zero
        levelButtons.name = "buttonGridContainer"
        self.createButtonGrid(inNode: levelButtons, rowCount: 4, columnCount: 3, buttonSize: CGSize(width: 90, height: 90), fontSize: 32, startAt: page*12 + 1)
        
        // Setting up main menu button.
        let mainMenuButton = SPGButton(withText: "Main Menu", size: CGSize(width: 150, height: 50), fontSize: 20, nodeName: "mainMenuButton")
        mainMenuButton.position = CGPoint(x: 0, y: levelButtons.position.y-(levelButtons.size.height/2)-70)
        
        // Setting up button to go to the next page.
        let nextButton = SPGButton(withText: "Next", size: CGSize(width: 80, height: 50), fontSize: 20, nodeName: "nextButton")
        nextButton.position = CGPoint(x: mainMenuButton.position.x + 125, y: mainMenuButton.position.y)
        
        // Setting up button to go to the previous page.
        let previousButton = SPGButton(withText: "Previous", size: CGSize(width: 80, height: 50), fontSize: 20, nodeName: "previousButton")
        previousButton.position = CGPoint(x: mainMenuButton.position.x - 125, y: mainMenuButton.position.y)
        
        // Setting up a label for the scene's title.
        let titleLabel = SKLabelNode(text: "Select Level")
        titleLabel.fontSize = 48
        titleLabel.fontColor = .white
        titleLabel.fontName = "Montserrat-Bold"
        titleLabel.position = CGPoint(x: 0, y: levelButtons.position.y+(levelButtons.size.height/2)+70)
        titleLabel.adjustFontSize(toFitRect: self.frame)
        
        // Adding children.
        self.addChild(levelButtons)
        self.addChild(mainMenuButton)
        self.addChild(titleLabel)
        self.addChild(nextButton)
        self.addChild(previousButton)
        
        // Adding gesture recongizers to tap levels and swipe between pages.
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextPage))
        swipeLeftRecognizer.direction = .left
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(previousPage))
        swipeRightRecognizer.direction = .right
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view?.addGestureRecognizer(swipeLeftRecognizer)
        self.view?.addGestureRecognizer(swipeRightRecognizer)
        self.view?.addGestureRecognizer(tapRecognizer)
    }
    
    /**
     Sets up a grid of buttons inside a given node.
     - parameter node: The node which the grid will be set up in.
     - parameter rowCount: The number of rows in the rid.
     - parameter columnCount: The number of columns in the grid.
     - parameter buttonSize: The size of the buttons in the grid.
     - parameter fontSize: The font size of the text in the buttons.
     - parameter startAt: The number in the first box on the grid. This determines which levels are displayed in the grid.
     */
    func createButtonGrid(inNode node: SKSpriteNode, rowCount: Int, columnCount: Int, buttonSize: CGSize, fontSize: CGFloat, startAt: Int) {
        
        // A point to offset each button so it they all will exist inside the node's frame.
        let buttonsOffset = CGPoint(x: -0.5*node.size.width+(buttonSize.width/2), y: 0.5*node.size.height-(buttonSize.height/2))
        
        // The spacing between each button.
        let buttonSpacing = CGSize(
            width: (node.size.width-buttonSize.width*CGFloat(columnCount))/(CGFloat(columnCount)-1),
            height: (node.size.height-buttonSize.height*CGFloat(rowCount))/(CGFloat(rowCount)-1)
        )
        
        // Double for loops setting up the grid.
        for row in 0...rowCount-1 {
            for column in 0...columnCount-1 {
                
                let number = row * columnCount + column + startAt
                
                let button = SPGButton(withText: "\(number)", size: buttonSize, fontSize: fontSize, nodeName: "level")
                
                let buttonPosition = CGPoint(x: column*Int(buttonSize.width), y: -1*Int(buttonSize.height)*row)
                
                button.position = CGPoint(
                    x: buttonPosition.x+buttonsOffset.x + buttonSpacing.width*CGFloat(column),
                    y: buttonPosition.y+buttonsOffset.y - buttonSpacing.height*CGFloat(row)
                )
                
                node.addChild(button)
            }
        }
    }
    
    /**
     Transitions to the next page of levels.
     */
    @objc func nextPage() {
        if self.animating { return }
        self.animating = true
        
        let currentPage = self.childNode(withName: "buttonGridContainer") as! SKSpriteNode
        
        // If we're not on the last page, we can go ahead and load the next page. Otherwise, animate a failed transition.
        if self.page < 4 {
            page += 1
            
            currentPage.run(SKAction.move(to: CGPoint(x: -1*currentPage.size.width-self.size.width, y: currentPage.position.y), duration: 0.2))
            
            let levelButtons = SKSpriteNode(color: .clear, size: CGSize(width: 300, height: 400))
            levelButtons.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            levelButtons.position = CGPoint(x: currentPage.size.width+self.size.width, y: currentPage.position.y)
            levelButtons.name = "buttonGridContainer"
            
            self.createButtonGrid(inNode: levelButtons, rowCount: 4, columnCount: 3, buttonSize: CGSize(width: 90, height: 90), fontSize: 32, startAt: page*12 + 1)
            
            self.addChild(levelButtons)
            
            levelButtons.run(SKAction.sequence([
                SKAction.move(to: .zero, duration: 0.2),
                SKAction.run({
                    currentPage.removeFromParent()
                    self.animating = false
                })
            ]))
            
        } else {
            currentPage.run(SKAction.sequence([
                SKAction.moveBy(x: -50, y: 0, duration: 0.05),
                SKAction.moveBy(x: 50, y: 0, duration: 0.05),
                SKAction.run {
                    self.animating = false
                }
            ]))
        }
    }
    
    /**
     Transitions to the previous page of levels.
     */
    @objc func previousPage() {
        if self.animating { return }
        self.animating = true
        
        let currentPage = self.childNode(withName: "buttonGridContainer") as! SKSpriteNode
        
        // If we're not on the first page, we can go ahead and load the previous page. Otherwise, animate a failed transition.
        if page > 0 {
            page -= 1
            
            currentPage.run(SKAction.move(to: CGPoint(x: currentPage.size.width+self.size.width, y: currentPage.position.y), duration: 0.2))
            
            let levelButtons = SKSpriteNode(color: .clear, size: CGSize(width: 300, height: 400))
            levelButtons.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            levelButtons.position = CGPoint(x: -1*currentPage.size.width-self.size.width, y: currentPage.position.y)
            levelButtons.name = "buttonGridContainer"
            
            self.createButtonGrid(inNode: levelButtons, rowCount: 4, columnCount: 3, buttonSize: CGSize(width: 90, height: 90), fontSize: 32, startAt: page*12 + 1)
            
            self.addChild(levelButtons)
            
            levelButtons.run(SKAction.sequence([
                SKAction.move(to: .zero, duration: 0.2),
                SKAction.run({
                    currentPage.removeFromParent()
                    self.animating = false
                })
            ]))
            
        } else {
            currentPage.run(SKAction.sequence([
                SKAction.moveBy(x: 50, y: 0, duration: 0.05),
                SKAction.moveBy(x: -50, y: 0, duration: 0.05),
                SKAction.run {
                    self.animating = false
                }
            ]))
        }
    }
    
    /**
     Recieves the tap gesture.
     */
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            var touchPoint = sender.location(in: self.view)
            touchPoint = CGPoint(x: touchPoint.x - (self.view?.bounds.width)!/2, y: ((self.view?.bounds.height)! - touchPoint.y) - (self.view?.bounds.height)!/2)
            self.touchDown(atPoint: touchPoint)
        }
    }
    
    /**
     Responds to the tap gesture.
     */
    func touchDown(atPoint pos : CGPoint) {
        for node in self.nodes(at: pos) {
            if node.name == "mainMenuButton" {
                let scene = MainMenuScene(size: (self.view?.bounds.size)!)
                let transition = SKTransition.fade(withDuration: 0.25)
                
                SPGSoundManager.shared.playButtonSound()
                
                self.view?.presentScene(scene, transition: transition)
                
            } else if node.name == "nextButton" {
                self.nextPage()
                
            } else if node.name == "previousButton" {
                self.previousPage()
                
            } else if node.name == "level" {
                let buttonText: String = (node as! SPGButton).buttonText.text!
                let transitionLevel: Int = Int(buttonText)!
                let scene = LevelTransitionScene(withSize: (self.view?.bounds.size)!, level: transitionLevel)
                let transition = SKTransition.fade(withDuration: 1)
                
                SPGSoundManager.shared.playButtonSound()
                
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
