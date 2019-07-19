//
//  Laser.swift
//  JTTD
//
//  Created by Jason Hoffman on 7/8/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import Foundation
import SpriteKit


class Laser: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        self.init(imageNamed: "laser")
        self.name = "laser"
        self.centerRect = CGRect(x: 14/30, y: 14/30, width: 0.1, height: 0.1)
        self.zPosition = 100
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.Laser
        physicsBody?.contactTestBitMask = PhysicsCategory.Meteor
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }

    
    func meteorColission() {
        
    }
    
//    func didMoveToScene() {
//        print("laser")
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
//        physicsBody?.affectedByGravity = false
//        physicsBody?.categoryBitMask = PhysicsCategory.Laser
//        physicsBody?.collisionBitMask = PhysicsCategory.Meteor
//    }

    
//    func newLaser() -> SKSpriteNode {
//        laser = SKSpriteNode(imageNamed: "laser")
//        laser.centerRect = CGRect(x: 14/30, y: 14/30, width: 0.1, height: 0.1)
//        laser.zPosition = 100
//        return laser
//    }
    
}
