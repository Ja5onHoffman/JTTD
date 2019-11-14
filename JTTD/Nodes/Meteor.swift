//
//  Meteor.swift
//  JTTD
//
//  Created by Jason Hoffman on 7/19/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import SpriteKit
import Foundation

struct MeteorPath {
    var p1: CGPoint
    var p2: CGPoint
}

class Meteor: SKSpriteNode {
    
    var scale = CGFloat.zero
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(path: (CGPoint, CGPoint)) { // add speed
        let num = Int.random(in: 1..<5)
        self.init(imageNamed: "meteor\(num)")
        self.name = "meteor"
        self.zPosition = 200 // Match with Poof zPostion
        scale = CGFloat.random(in: 0.5..<2)
        self.setScale(scale)
        self.position = path.0
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        let flight = SKAction.move(to: path.1, duration: 4.0)
        let seq = SKAction.sequence([flight, SKAction.removeFromParent()])
        run(seq)
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
    
    func toggleCollision() {
        if self.physicsBody?.collisionBitMask == PhysicsCategory.Ship {
            self.physicsBody?.collisionBitMask = PhysicsCategory.None
        } else {
            self.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        }
    }

    
}
