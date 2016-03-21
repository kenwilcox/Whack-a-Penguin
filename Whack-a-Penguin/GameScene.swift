//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Kenneth Wilcox on 3/20/16.
//  Copyright (c) 2016 Kenneth Wilcox. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var slots = [WhackSlot]()
  
  var gameScore: SKLabelNode!
  var score: Int = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    let background = SKSpriteNode(imageNamed: "whackBackground")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .Replace
    background.zPosition = -1
    addChild(background)
    
    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.text = "Score: 0"
    gameScore.position = CGPoint(x: 8, y: 8)
    gameScore.horizontalAlignmentMode = .Left
    gameScore.fontSize = 48
    addChild(gameScore)
    
    for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
    for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
    for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
    for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
  
  func createSlotAt(pos: CGPoint) {
    let slot = WhackSlot()
    slot.configureAtPosition(pos)
    addChild(slot)
    slots.append(slot)
  }
}
