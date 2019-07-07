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
    let radiansPerSec: CGFloat = 4.0 * π
    let movePointsPerSec: CGFloat = 500.0
    
    func didMoveToScene() {
        print("test ship")
        isPaused = false
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.0
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
    
    func swapMove() {
        moved = !moved
    }
}
