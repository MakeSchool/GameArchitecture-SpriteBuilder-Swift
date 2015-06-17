//
//  WinPopup.swift
//  GameArchitecture
//
//  Created by Dion Larson on 6/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class WinPopup: CCNode {
  
  var nextLevelName = "Level1"
  
  func loadNextLevel() {
    let restartScene = CCBReader.loadAsScene(nextLevelName)
    let transition = CCTransition(fadeWithDuration: 0.8)
    CCDirector.sharedDirector().presentScene(restartScene, withTransition: transition)
  }
  
}