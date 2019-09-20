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
        isPaused = false
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Mother
        physicsBody?.collisionBitMask = PhysicsCategory.None
        physicsBody?.contactTestBitMask = PhysicsCategory.Meteor
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
    
    func shipHit() {
        shakeShipByAmt(20)
    
    }
    
    func shakeShipByAmt(_ amt: CGFloat) {
        self.removeAction(forKey: "shake")
        let amount = CGPoint(x: 0, y: -amt)
        let action = SKAction.screenShakeWithNode(self, amount: amount, oscillations: 10, duration: 0.5)
        run(action, withKey: "shake")
    }


}
