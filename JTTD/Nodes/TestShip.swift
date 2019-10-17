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
    var dot: SKSpriteNode?
    var line: SKShapeNode!
    
    func didMoveToScene() {
        print("test ship")
        isPaused = false
        isUserInteractionEnabled = true
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Ship
        physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
        physicsBody?.contactTestBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Redraw line in collision for smoother line
        self.removeAllChildren()
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        print(positionInScene)
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: positionInScene.x, y: positionInScene.y))
        
        let line = SKShapeNode(path: path)
        line.name = "line"
        line.zPosition = 5000
        line.strokeColor = UIColor.red
        line.lineWidth = 20
        line.fillColor = UIColor.red

        
        self.addChild(line)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAllChildren()  // remove line
    }
    
    
//    func lineBetween(firstSprite: SKSpriteNode, secondSprite: SKSpriteNode) {
//         let offset = firstSprite.position - secondSprite.position
//         let length = offset.length() - 94
//         let direction = offset / CGFloat(length)
//         laser = Laser()
//         laser.xScale = length / laser.size.width
//         laser.yScale = CGFloat(4.0 / (laser.xScale).squareRoot()) // This isn't great but works
//         simpleRotate(sprite: laser, direction: direction)
//         laser.position = CGPoint(midPointBetweenA: firstSprite.position, andB: secondSprite.position)
//         fgNode.addChild(laser)
//     }
    
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
        // No invincible or blinking for now
//        invincible = true
//        let blinkTimes = 10.0
//        let duration = 3.0
        health -= 0.1
        
        if health > 0 {
//            let blinkAction = SKAction.customAction(withDuration: duration) { (node, elapsedTime) in
//                let slice = duration / blinkTimes
//                let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
//                node.isHidden = remainder > slice / 2
//            }
//            let setHidden = SKAction.run {
//                self.isHidden = false
//                self.invincible = false
//            }
//            run(SKAction.sequence([blinkAction, setHidden]))
            
            healthBar.updateHealth(by: health)
            // lives, etc here
        } else if health <= 0 {
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
