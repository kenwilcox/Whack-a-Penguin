//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Kenneth Wilcox on 3/20/16.
//  Copyright (c) 2016 Kenneth Wilcox. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var slots = [WhackSlot]()
  
  var popupTime = 0.85
  var maxRounds = 30
  
  var rounds: SKLabelNode!
  var numRounds: Int = 0 {
    didSet {
      rounds.text = "\(maxRounds - numRounds) "
    }
  }
  
  var gameScore: SKLabelNode!
  var score: Int = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }
  var gameOver: SKSpriteNode!
  
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
    
    rounds = SKLabelNode(fontNamed: "Chalkduster")
    rounds.text = " 30 "
    rounds.position = CGPoint(x: self.frame.width - rounds.frame.size.width, y: 8)
    rounds.horizontalAlignmentMode = .Right
    rounds.fontSize = 48
    addChild(rounds)
    
    for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
    for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
    for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
    for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }
    
    // pre load sounds
    _ = SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false)
    _ = SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false)
    
    reset()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    if let touch = touches.first {
      let location = touch.locationInNode(self)
      let nodes = nodesAtPoint(location)
      
      for node in nodes {
        if node.name == "charFriend" {
          // they shouldn't have whacked this penguin
          let whackSlot = node.parent!.parent as! WhackSlot
          if !whackSlot.visible { continue }
          if whackSlot.isHit { continue }
          
          whackSlot.hit()
          score -= 5
          
          runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
        } else if node.name == "charEnemy" {
          // they should have whacked this one
          let whackSlot = node.parent!.parent as! WhackSlot
          if !whackSlot.visible { continue }
          if whackSlot.isHit { continue }
          
          whackSlot.charNode.xScale = 0.85
          whackSlot.charNode.yScale = 0.85
          
          whackSlot.hit()
          score += 1
          
          runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
        } else if node.name == "gameOver" {
          reset()
        }
      }
    }
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
  
  func createEnemy() {
    numRounds += 1
    
    if numRounds >= maxRounds {
      for slot in slots {
        slot.hide()
      }
      
      gameOver = SKSpriteNode(imageNamed: "gameOver")
      gameOver.name = "gameOver"
      gameOver.position = CGPoint(x: 512, y: 384)
      gameOver.zPosition = 1
      addChild(gameOver)

      return
    }
    
    popupTime *= 0.991
    
    slots = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(slots) as! [WhackSlot]
    slots[0].show(hideTime: popupTime)
    
    if Random.int(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
    if Random.int(min: 0, max: 12) > 8 { slots[2].show(hideTime: popupTime) }
    if Random.int(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
    if Random.int(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime) }
    
    let minDelay = popupTime / 2.0
    let maxDelay = popupTime * 2
    
    RunAfterDelay(Random.double(min: minDelay, max: maxDelay)) { [unowned self] in
      self.createEnemy()
    }
  }
  
  func reset() {
    popupTime = 0.85
    score = 0
    numRounds = 0
    gameOver?.removeFromParent()
    RunAfterDelay(1) { [unowned self] in
      self.createEnemy()
    }
  }
}
