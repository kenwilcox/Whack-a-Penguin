//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Kenneth Wilcox on 3/21/16.
//  Copyright © 2016 Kenneth Wilcox. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
  
  func configureAtPosition(pos: CGPoint) {
    position = pos
    
    let sprite = SKSpriteNode(imageNamed: "whackHole")
    addChild(sprite)
  }
  
}
