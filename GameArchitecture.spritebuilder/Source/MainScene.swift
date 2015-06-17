//
//  MainScene.swift
//  GameArchitecture
//
//  Created by Dion Larson on 6/16/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation

class MainScene: CCNode {
  
  func startGame() {
    // CHANGE: Load gameplay as scene
    let firstLevel = CCBReader.loadAsScene("Gameplay")
    let transition = CCTransition(fadeWithDuration: 0.8)
    CCDirector.sharedDirector().presentScene(firstLevel, withTransition: transition)
  }

}
