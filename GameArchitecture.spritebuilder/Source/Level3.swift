//
//  Level1.swift
//  GameArchitecture
//
//  Created by Dion Larson on 6/16/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation

class Level3: CCNode, CCPhysicsCollisionDelegate {
  
  weak var character: CCSprite!
  weak var gamePhysicsNode: CCPhysicsNode!
  var jumped = false
  
  func didLoadFromCCB() {
    gamePhysicsNode.collisionDelegate = self
  }
  
  override func onEnter() {
    super.onEnter()
    
    let follow = CCActionFollow(target: character, worldBoundary: gamePhysicsNode.boundingBox())
    gamePhysicsNode.position = follow.currentOffset()
    gamePhysicsNode.runAction(follow)
  }
  
  override func onEnterTransitionDidFinish() {
    super.onEnterTransitionDidFinish()
    
    self.userInteractionEnabled = true
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    // only runs if character is colliding with another physics object (eg. ground)
    character.physicsBody.eachCollisionPair { (pair) -> Void in
      if !self.jumped {
        self.character.physicsBody.applyImpulse(CGPoint(x: 0, y: 2000))
        self.jumped = true
        
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
      }
    }
  }
  
  func resetJump() {
    jumped = false
  }
  
  override func fixedUpdate(delta: CCTime) {
    character.physicsBody.velocity = CGPoint(x: 40, y: character.physicsBody.velocity.y)
  }

  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, flag: CCNode!) -> Bool {
    paused = true
    
    let popup = CCBReader.load("WinPopup") as! WinPopup
    popup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
    popup.position = CGPoint(x: 0.5, y: 0.5)
    popup.nextLevelName = "MainScene"
    parent.addChild(popup)
    
    return true
  }
  
  override func update(delta: CCTime) {
    if CGRectGetMaxX(character.boundingBox()) < CGRectGetMinY(gamePhysicsNode.boundingBox()) {
      gameOver()
    }
  }
  
  func gameOver() {
    let restartScene = CCBReader.loadAsScene("Level3")
    let transition = CCTransition(fadeWithDuration: 0.8)
    CCDirector.sharedDirector().presentScene(restartScene, withTransition: transition)
  }
}
