//
//  Beam.swift
//  JTTD
//
//  Created by Jason Hoffman on 10/19/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import SpriteKit

// Not currently used
class Beam: SKSpriteNode, EventListenerNode {
    
    func didMoveToScene() {
        isPaused = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.Recharge
        physicsBody?.collisionBitMask = PhysicsCategory.None
        physicsBody?.contactTestBitMask = PhysicsCategory.Ship
    }

}
