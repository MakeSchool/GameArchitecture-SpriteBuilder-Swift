//
//  Gameplay.swift
//  GameArchitecture
//
//  Created by Dion Larson on 6/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

// CHANGE: moved majority of code from LevelX classes to Gameplay class and
//         LevelX classes removed to reduce code duplication

class Gameplay: CCNode {
  
  // CHANGE: levelNode for holding levels
  weak var levelNode: CCNode!
  // CHANGE: loadedLevel for current level playing
  weak var loadedLevel: Level!
  // CHANGE: set after CCBReader.load(), before presentScene to choose level
  var levelToLoad = "Level1"
  // CHANGE: level speed loaded from Level class
  var levelSpeed = CGFloat(40)
  
  // CHANGE: character gets set by CCBReader.load(:owner:)
  weak var character: CCSprite!
  weak var gamePhysicsNode: CCPhysicsNode!
  var jumped = false
  // CHANGE: added for star collection
  weak var scoreLabel: CCLabelTTF!
  var score = 0 {
    didSet {
      scoreLabel.string = "\(score)"
    }
  }

// MARK: Node Lifecycle
  
  func didLoadFromCCB() {
    gamePhysicsNode.collisionDelegate = self
  }
  
  override func onEnter() {
    super.onEnter()
    
    // CHANGE: load in level from onEnter, set levelSpeed
    loadedLevel = CCBReader.load(levelToLoad, owner: self) as! Level
    levelNode.addChild(loadedLevel)
    levelSpeed = CGFloat(loadedLevel.levelSpeed)
    
    // CHANGE: use loadedLevel's bounding box instead
    let follow = CCActionFollow(target: character, worldBoundary: loadedLevel.boundingBox())
    gamePhysicsNode.position = follow.currentOffset()
    gamePhysicsNode.runAction(follow)
  }
  
  override func onEnterTransitionDidFinish() {
    super.onEnterTransitionDidFinish()
    
    self.userInteractionEnabled = true
  }
  
// MARK: Level completion
  
  // CHANGE: WinPopup now calls this since target is owner (self)
  func loadNextLevel() {
    var nextScene: CCScene!
    if loadedLevel.nextLevelName == "MainScene" {
      nextScene = CCBReader.loadAsScene("MainScene")
    } else {
      nextScene = setupGameplayScene(loadedLevel.nextLevelName)
    }
    
    let transition = CCTransition(fadeWithDuration: 0.8)
    CCDirector.sharedDirector().presentScene(nextScene, withTransition: transition)
  }
  
  // CHANGE: helper method for setting up Gameplay in a scene with levelToLoad
  func setupGameplayScene(level: String) -> CCScene {
    let gameplay = CCBReader.load("Gameplay") as! Gameplay
    gameplay.levelToLoad = level
    
    let scene = CCScene()
    scene.addChild(gameplay)
    return scene
  }
  
// MARK: Touch Handling
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    // only runs if character is colliding with another physics object (eg. ground)
    character.physicsBody.eachCollisionPair { (pair) -> Void in
      if !self.jumped {
        // CHANGE: lowered jump height
        self.character.physicsBody.applyImpulse(CGPoint(x: 0, y: 1000))
        self.jumped = true
        
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
      }
    }
  }

// MARK: Player Movement
  
  func resetJump() {
    jumped = false
  }
  
  override func fixedUpdate(delta: CCTime) {
    // CHANGE: use levelSpeed loaded from Level instead of fixed value of 40
    character.physicsBody.velocity = CGPoint(x: levelSpeed, y: character.physicsBody.velocity.y)
  }
  
// MARK: Collision Handling
  
  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, flag: CCNode!) -> Bool {
    paused = true
    
    let popup = CCBReader.load("WinPopup", owner:self) as! WinPopup
    popup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
    popup.position = CGPoint(x: 0.5, y: 0.5)
    parent.addChild(popup)
    
    return true
  }
  
  // CHANGE: added to handle collisions with stars
  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, star: CCNode!) -> Bool {
    star.removeFromParent()
    score++
    
    // return false ignores the collision
    return false
  }
  
// MARK: Update
  
  override func update(delta: CCTime) {
    if CGRectGetMaxX(character.boundingBox()) < CGRectGetMinY(gamePhysicsNode.boundingBox()) {
      gameOver()
    }
  }
  
// MARK: Game Over
  
  func gameOver() {
    // CHANGE: use setupGameplayScene helper method
    let restartScene = setupGameplayScene(levelToLoad)
    let transition = CCTransition(fadeWithDuration: 0.8)
    CCDirector.sharedDirector().presentScene(restartScene, withTransition: transition)
  }
  
}