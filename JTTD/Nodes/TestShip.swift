//
//  TestShip.swift
//  JTTD
//
//  Created by Jason Hoffman on 6/29/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import SpriteKit

enum ShipSettings {
    static let shipSpeed: CGFloat = 280.0
}

class TestShip: SKSpriteNode, EventListenerNode {
    
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var moved: Bool = false
    var velocity: CGPoint = CGPoint.zero
    var invincible = false
    let radiansPerSec: CGFloat = 4.0 * π
    let movePointsPerSec: CGFloat = 500.0
    var health: CGFloat = 1.0
    var healthBar: HealthBar!
    
    func didMoveToScene() {
        print("test ship")
        isPaused = false
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Ship
        physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
        physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
    }
    
    func updateTimes(dt: TimeInterval, lastUpdateTime: TimeInterval) {
        self.dt = dt
        self.lastUpdateTime = lastUpdateTime
    }
    
    func move(to location: CGPoint, speed: TimeInterval, completion: (() -> Void)?) {
        moved = !moved
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.angularVelocity = 0.0
        let moveAction = SKAction.move(to: location, duration: speed)
        rotate(directionOf: location)
        run(moveAction) {
            completion?()
        }
    }

    func rotate(directionOf location: CGPoint) {
        let angle = atan2(location.y - position.y , location.x - position.x)
        let rotateAction = SKAction.rotate(toAngle: angle - CGFloat(-π/2), duration: 0.1, shortestUnitArc: true)
        run(rotateAction)
    }
    
    func shipHit() {
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        health -= 0.1
        
        if health > 0 {
            let blinkAction = SKAction.customAction(withDuration: duration) { (node, elapsedTime) in
                let slice = duration / blinkTimes
                let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
                node.isHidden = remainder > slice / 2
            }
            let setHidden = SKAction.run {
                self.isHidden = false
                self.invincible = false
            }
            
            healthBar.updateHealth(by: health)
            run(SKAction.sequence([blinkAction, setHidden]))
            // lives, etc here
        } else {
            explode()
        }
        
    }
    
    func explode() {
        let particles = SKEmitterNode(fileNamed: "Poof")!
        particles.position = position
        particles.zPosition = 3
        let fg = self.parent
        fg?.addChild(particles)
        removeFromParent()
        particles.run(SKAction.removeFromParentAfterDelay(0.5))
    }
    
    
    func swapMove() {
        moved = !moved
    }
}
