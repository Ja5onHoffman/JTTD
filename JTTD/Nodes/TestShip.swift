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
    var health: Int = 100
    var shield: Int = 100
    var healthBar: HealthBar!
    var shieldBar: HealthBar!
    var dot: SKSpriteNode?
    var line: SKShapeNode!
    var superShield = false
    
    func didMoveToScene() {
        isPaused = false
        isUserInteractionEnabled = true
        zPosition = 1000
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Ship
        physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
        physicsBody?.contactTestBitMask =
            PhysicsCategory.Meteor |
            PhysicsCategory.Ship |
            PhysicsCategory.Recharge
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Redraw line in collision for smoother line
        self.childNode(withName: "line")?.removeFromParent()
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: positionInScene.x, y: positionInScene.y))
        
        let line = SKShapeNode(path: path)
        line.name = "line"
        line.zPosition = zPosition - 1
        line.strokeColor = UIColor.red
        line.lineWidth = 20
        line.fillColor = UIColor.red

        self.addChild(line)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.childNode(withName: "line")?.removeFromParent()
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self.parent!)
        move(to: positionInScene, speed: 0.3, completion: nil)
    }
    
    func updateTimes(dt: TimeInterval, lastUpdateTime: TimeInterval) {
        self.dt = dt
        self.lastUpdateTime = lastUpdateTime
    }
    
    func move(to location: CGPoint, speed: TimeInterval, completion: (() -> Void)?) {
        moved = !moved
        physicsBody?.collisionBitMask = PhysicsCategory.None | PhysicsCategory.Token
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.angularVelocity = 0.0
        let moveAction = SKAction.move(to: location, duration: speed)
        rotate(directionOf: location)
        run(moveAction) {
            self.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
            completion?() 
        }
    }

    func rotate(directionOf location: CGPoint) {
        let angle = atan2(location.y - position.y , location.x - position.x)
        let rotateAction = SKAction.rotate(toAngle: angle - CGFloat(-π/2), duration: 0.1, shortestUnitArc: true)
        run(rotateAction)
    }
    
    func shipHit() {
        if (shield > 0) {
            shield -= 10
            shieldBar.decreaseHealth(by: shield)
            updateShield(shield)
        } else if (shield == 0) {
            health -= 10
            if health > 0 {
                healthBar.decreaseHealth(by: health)
                // lives, etc here
            } else if health <= 0 {
                explode()
            }
        }
    }
    
    // Just increments for now
    func recharge() {
        shield += 10
        shieldBar.increaseHealth(by: 10)
        if let s = childNode(withName: "shield") {
            if s.xScale == 0 {
                let scaleBig = SKAction.scale(to: 0.5, duration: 1.0)
                s.run(scaleBig)
            }
            s.alpha = CGFloat(shield) / 100
        }
    }
    
    // Need to change this to increase shield as well
    func updateShield(_ level: Int) {
        if let s = childNode(withName: "shield") {
            if s.alpha > 0 {
                s.alpha = CGFloat(shield) / 100
            }
        }
        if level == 0 {
            let alpha = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            let white = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 1.0)
            let scaleBig = SKAction.scale(to: 2.0, duration: 1.0)
            let scaleSmall = SKAction.scale(to: 0.0, duration: 1.0)
            let particles = SKAction.run { self.emitParticles(name: "ShieldPoof") }
            let set = SKAction.group([particles, alpha, white, scaleBig, scaleSmall])
            if let s = childNode(withName: "shield") {
                s.run(set)
                s.run(SKAction.scaleX(to: 1.0, duration: 0.0))
            }
        }
        
    }
    
    func emitParticles(name: String) {
        let pos = convert(position, from: parent!)
        let particles = SKEmitterNode(fileNamed: name)!
        particles.position = pos
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.fadeOut(withDuration: 1)) {
            particles.removeFromParent()
        }
    }
    
    func blink() {
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        let blinkAction = SKAction.customAction(withDuration: duration) { (node, elapsedTime) in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run {
            self.isHidden = false
            self.invincible = false
            self.physicsBody?.collisionBitMask = PhysicsCategory.Meteor | PhysicsCategory.Ship
        }
        run(SKAction.sequence([blinkAction, setHidden]))
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
    
    func addSuperShield() {
        superShield = !superShield
        if let superShield = SKEmitterNode(fileNamed: "SuperShield") {
            superShield.targetNode = self
            superShield.setScale(2.0)
            superShield.position = CGPoint(x: -0.945, y: -3.136)
            superShield.alpha = 0.0
            if let s = childNode(withName: "shield") {
                let seq = SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.3),
                SKAction.afterDelay(5.0, performAction: SKAction.fadeIn(withDuration: 0.3))])
                s.run(seq)
            }
            
            self.addChild(superShield)
            run(SKAction.afterDelay(5.0, performAction: SKAction.run {
                let fade = SKAction.fadeOut(withDuration: 1.0)
                superShield.run(fade) { // Doesn't fade\
                    superShield.removeFromParent()
                }
            }))
            
        }
    }
    
    func swapMove() {
        moved = !moved
    }
    
    func printShields() {
        let s = childNode(withName: "shield")!
        print("Shield: \(shield)")
        print("SA: \(s.alpha)")
        print(CGFloat(shield) / 100)
    }
}
