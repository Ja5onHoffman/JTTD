//
//  Meteor.swift
//  JTTD
//
//  Created by Jason Hoffman on 7/19/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import SpriteKit

class Meteor: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    convenience init() {
        let num = Int.random(in: 1..<5)
        let meteor = SKSpriteNode(imageNamed: "meteor\(num)")
        meteor.name = "meteor"
        meteor.zPosition = 100
        meteor.setScale(CGFloat.random(in: 0.5..<2))
        let path = meteorPath()
        meteor.position = path.0
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 2)
        meteor.physicsBody?.affectedByGravity = true
        meteor.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        meteor.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        meteor.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        
        let flight = SKAction.move(to: path.1, duration: 4.0)
        let seq = SKAction.sequence([flight, SKAction.removeFromParent()])
    }
    
    
    func meteor() {
        let num = Int.random(in: 1..<5)
        let meteor = SKSpriteNode(imageNamed: "meteor\(num)")
        meteor.name = "meteor"
        meteor.zPosition = 100
        meteor.setScale(CGFloat.random(in: 0.5..<2))
        let path = meteorPath()
        meteor.position = path.0
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 2)
        meteor.physicsBody?.affectedByGravity = true
        meteor.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        meteor.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        meteor.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        
        let flight = SKAction.move(to: path.1, duration: 4.0)
        let seq = SKAction.sequence([flight, SKAction.removeFromParent()])
        meteor.run(seq)
//        fgNode.addChild(meteor)
    }
    
    
    func meteorPath() -> (CGPoint, CGPoint) {
        guard let p = parent?.scene else { return (CGPoint.zero, CGPoint.zero) }
        let theZone = CGRect(x: (-p.size.width / 2) - 100, y: (p.size.height / 2) - 100, width: p.size.width + 200, height: 400)
        let topView = CGRect(x: -p.size.width / 2, y: (p.size.height/2) - 100, width: p.size.width, height: 100)
        let intersection = theZone.intersection(topView)
        var randomX: CGFloat
        var randomY: CGFloat
        repeat {
            randomX = CGFloat.random(min: (-p.size.width / 2) - 100, max: p.size.width + 200)
            randomY = CGFloat.random(min: (p.size.height / 2) - 100, max: (p.size.height/2) + 300)
        } while intersection.contains(CGPoint(x: randomX, y: randomY))
        
        let bottomX = CGFloat.random(min: -p.size.width / 2, max: p.size.width / 2)
        
        return (CGPoint(x: randomX, y: randomY), CGPoint(x: bottomX, y: (-p.size.height / 2) - 100))
    }
    
    
}
