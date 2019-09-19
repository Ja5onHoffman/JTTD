//
//  Mothership.swift
//  JTTD
//
//  Created by Jason Hoffman on 9/19/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import Foundation
import SpriteKit

enum MothershipSettings {
    static var shipNum = 0
}


class Mothership: SKSpriteNode, EventListenerNode {

    let mothership = SKSpriteNode(imageNamed: "mothership10")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        self.init(imageNamed: "mothership10")
        self.name = "mothership"
        self.zPosition = 100
    }
    
    func didMoveToScene() {
        beginMovement()
    }
    
    func beginMovement() {
        let leftUp = SKAction.moveBy(x: -400, y: 100, duration: 4.0)
        let leftDown = SKAction.moveBy(x: -400, y: -100, duration: 4.0)
        let rightUp = SKAction.moveBy(x: 400, y: 100, duration: 4.0)
        let rightDown = SKAction.moveBy(x: 400, y: -100, duration: 4.0)
        let seq = SKAction.sequence([leftUp, rightDown, rightUp, leftDown])
        let rep = SKAction.repeatForever(seq)
        run(rep)
    }
    
//    convenience init() {
//        self.init(imageNamed: "laser")
//        self.name = "laser"
//        self.centerRect = CGRect(x: 14/30, y: 14/30, width: 0.1, height: 0.1)
//        self.zPosition = 100
//        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
//        physicsBody?.affectedByGravity = false
//        physicsBody?.categoryBitMask = PhysicsCategory.Laser
//        physicsBody?.contactTestBitMask = PhysicsCategory.Meteor
//        physicsBody?.collisionBitMask = PhysicsCategory.None
//    }
}
