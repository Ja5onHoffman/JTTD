//
//  GameScene.swift
//  JTTD
//
//  Created by Jason Hoffman on 4/27/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
// 

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var background: SKSpriteNode!
    var backgroundStars: SKEmitterNode!
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNext")
    let levelLabel = SKLabelNode(fontNamed: "AvenirNext")
    
    var bgNode: SKNode!
    var fgNode: SKNode!
    var overlay: SKNode!
    var meteor: Meteor!
    var border: SKShapeNode!
    var catchLine: SKShapeNode!
    var catchLinePath: CGMutablePath!
    var laser: SKSpriteNode!
    var dotCount: Int = 0
    var shipOne: TestShip!
    var shipTwo: TestShip!
    var lastTouchLocation: CGPoint?
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity = CGPoint.zero
    let shipMovePointsPerSec: CGFloat = 700.0
    
    override func didMove(to view: SKView) {
        setupNodes()
        basicShips()
        let sr = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.0)
        shipOne.run(sr)
        self.physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run({
            let m = Meteor(path: self.path())
            self.fgNode.addChild(m)
        }), SKAction.wait(forDuration: 2.0)])))
        
        let healthBg = SKSpriteNode(imageNamed: "Healthbackground")
        healthBg.position = CGPoint
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        laser.removeFromParent()
        
        if shipOne.moved {
            self.shipOne.swapMove()
            shipTwo.move(to: positionInScene, speed: 0.3) {
                self.shipTwo.rotate(directionOf: self.shipOne.position)
                self.shipOne.rotate(directionOf: self.shipTwo.position)
                self.lineBetween(firstSprite: self.shipOne, secondSprite: self.shipTwo)
            }
        } else {
            if let l = self.laser {
                l.removeFromParent()
            }
            shipOne.move(to: positionInScene, speed: 0.3, completion: nil)
        }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }

    // MARK: Collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let bA = contact.bodyA.categoryBitMask
        let bB = contact.bodyB.categoryBitMask
        
        // Meteor vs Laser
        if (bA == PhysicsCategory.Laser && bB == PhysicsCategory.Meteor) || (bA == PhysicsCategory.Meteor && bB == PhysicsCategory.Laser) {
//            let wait = SKAction.wait(forDuration: 0.2)
            if contact.bodyA.node?.name == "meteor" {
                explode(node: contact.bodyA.node as! SKSpriteNode, time: TimeInterval(contact.bodyA.node!.frame.size.width / 500))
            } else {
                explode(node: contact.bodyB.node as! SKSpriteNode, time: TimeInterval(contact.bodyB.node!.frame.size.width / 500))
            }
        
        // Ship vs Meteor
        } else if (bA == PhysicsCategory.Ship && bB == PhysicsCategory.Meteor) || (bA == PhysicsCategory.Meteor && bB == PhysicsCategory.Ship) {
            laser.removeFromParent()
        
            if contact.bodyA.node?.name == "meteor" {
                explode(node: contact.bodyA.node as! SKSpriteNode, time: TimeInterval(contact.bodyA.node!.frame.size.width / 500))
                let ship = contact.bodyB.node as! TestShip
                ship.shipHit()
            } else {
                explode(node: contact.bodyB.node as! SKSpriteNode, time: TimeInterval(contact.bodyA.node!.frame.size.width / 500))
                let ship = contact.bodyA.node as! TestShip
                ship.shipHit()
            }
            
        // Mothership vs Meteor
        } else if (bA == PhysicsCategory.Mother && bB == PhysicsCategory.Meteor) || (bA == PhysicsCategory.Meteor && bB == PhysicsCategory.Mother) {
            if contact.bodyA.node?.name == "meteor" {
                explode(node: contact.bodyA.node as! SKSpriteNode, time: TimeInterval(contact.bodyA.node!.frame.size.width / 500))
                let ship = contact.bodyB.node as! Mothership
                ship.shipHit()
            } else {
                explode(node: contact.bodyB.node as! SKSpriteNode, time: TimeInterval(contact.bodyB.node!.frame.size.width / 500))
                let ship = contact.bodyA.node as! Mothership
                ship.shipHit()
            }
        }
    }
    

    // MARK: Setup
    func setupNodes() {
        let worldNode = childNode(withName: "World")!
        fgNode = worldNode.childNode(withName: "Foreground")
        bgNode = worldNode.childNode(withName: "Background")
        background = bgNode.childNode(withName: "background") as? SKSpriteNode
        backgroundStars = SKEmitterNode(fileNamed: "BackgroundStars")!
        backgroundStars.targetNode = bgNode
        backgroundStars.position = CGPoint(x: 0, y: size.height)
        backgroundStars.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        backgroundStars.zPosition = -1
        bgNode.addChild(backgroundStars)
        laser = Laser()
    }
    
    
    func newLaser() -> SKSpriteNode {
        laser = SKSpriteNode(imageNamed: "laser")
        laser.centerRect = CGRect(x: 14/30, y: 14/30, width: 0.1, height: 0.1)
        laser.zPosition = 100
        return laser
    }
    
    func basicShips() {
        shipOne = SKSpriteNode(fileNamed: "TestShip")?.childNode(withName: "basicShip") as? TestShip
        shipOne.setScale(1)
        shipOne.position = CGPoint(x: -100, y: 0)
        shipOne.color = SKColor.red
        
        shipTwo = SKSpriteNode(fileNamed: "TestShip")?.childNode(withName: "basicShip") as? TestShip
        shipTwo.setScale(1)
        shipTwo.position = CGPoint(x: 100, y: 0)
        
        let mothership = Mothership()
        mothership.position = CGPoint(x: 0, y: -800)
        mothership.setScale(2)
            
        shipOne.move(toParent: fgNode)
        shipTwo.move(toParent: fgNode)
        mothership.move(toParent: fgNode)
    }
    
    func greenDot(position: CGPoint) {
        let gd = SKSpriteNode(imageNamed: "greendot")
        gd.name = "greenDot_\(dotCount)"
        dotCount += 1
        gd.zPosition = 101
        gd.setScale(0.25)
        gd.physicsBody = SKPhysicsBody(circleOfRadius: gd.size.width / 2)
        gd.physicsBody?.affectedByGravity = false
        gd.position = position
        fgNode.addChild(gd)
    }
    
    func lineBetween(firstSprite: SKSpriteNode, secondSprite: SKSpriteNode) {
        let offset = firstSprite.position - secondSprite.position
        let length = offset.length() - 94
        let direction = offset / CGFloat(length)
        laser = Laser()
        laser.xScale = length / laser.size.width
        laser.yScale = CGFloat(4.0 / (laser.xScale).squareRoot()) // This isn't great but work
        simpleRotate(sprite: laser, direction: direction)
        laser.position = CGPoint(midPointBetweenA: firstSprite.position, andB: secondSprite.position)
        fgNode.addChild(laser)
    }
    
    
    func laserFrom(firstShip: SKSpriteNode, to secondShip: SKSpriteNode) {
        laser.removeFromParent()
        let p1 = firstShip.position
        let p2 = secondShip.position
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        let length = sqrt(dx*dx + dy*dy)
        let angle = atan2(dy, dx)
        laser = newLaser()
        laser.position = p1
        laser.xScale = length / laser.size.width
        laser.zRotation = angle
        fgNode.addChild(laser)
    }
    
    func stretchLaserTo(_ point: CGPoint) {
        let dx = point.x - laser.position.x
        let dy = point.y - laser.position.y
        let length = sqrt(dx*dx + dy*dy)
        let angle = atan2(dy, dx)
        laser.xScale = length / laser.size.width
        laser.zRotation = angle
    }

    func scaleDot() {
        let dot = SKSpriteNode(imageNamed: "dot")
        dot.isUserInteractionEnabled = true
        dot.name = "dot"
        dot.zPosition = 100
        let randomX = CGFloat.random(min: -size.width / 2 + 50, max: size.width / 2 - 50)
        dot.position = CGPoint(x: randomX, y: size.height + 50)
        dot.physicsBody = SKPhysicsBody(circleOfRadius: dot.size.width / 2)
        let grow = SKAction.scale(to: 1.0, duration: 2.0)
        let shrink = SKAction.scale(to: 0, duration: 2.0)
        let rem = SKAction.removeFromParent()
        let seq = SKAction.sequence([grow, shrink, rem])
//        let rep = SKAction.repeatForever(seq)
        dot.run(seq)
        fgNode.addChild(dot)
    }
    
    // MARK: Animation
    
    func explode(node: SKSpriteNode, time: TimeInterval) {
        let num = Int.random(in: 1..<5)
        let blend = SKAction.animate(with: [SKTexture(imageNamed: "\(node.name!)\(num)ex")], timePerFrame: time)
        blend.timingMode = .easeIn
        node.run(blend) {
            self.emitParticles(name: "Poof", sprite: node)
            self.laser.removeFromParent()
            node.removeFromParent()
        }
        
    }

    func moveShipToward(location: CGPoint) {
        let offset = location - shipOne.position
        let length = offset.length()
        let direction = offset / CGFloat(length)
        velocity = direction * 700
        let moveAction = SKAction.move(to: location, duration: 0.5)
        shipOne.run(moveAction)
    }
    
    func emitParticles(name: String, sprite: SKSpriteNode) {
        let pos = fgNode.convert(sprite.position, from: sprite.parent!)
        let particles = SKEmitterNode(fileNamed: name)!
        particles.position = pos
        particles.zPosition = 3
        fgNode.addChild(particles)
        sprite.removeFromParent()
        particles.run(SKAction.removeFromParentAfterDelay(0.5))
    }
    
    func move(ship: SKSpriteNode, toward location: CGPoint, completion: () -> Void?) {
        ship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let moveAction = SKAction.move(to: location, duration: 0.3)
        ship.run(moveAction)
    }
    
    func path() -> (CGPoint, CGPoint) {
        guard let _ = scene else { return (CGPoint.zero, CGPoint.zero) }
        let theZone = CGRect(x: (-size.width / 2) - 100, y: (size.height / 2) - 100, width: size.width + 200, height: 400)
        let topView = CGRect(x: -size.width / 2, y: (size.height/2) - 100, width: size.width, height: 100)
        let intersection = theZone.intersection(topView)
        var randomX: CGFloat
        var randomY: CGFloat
        repeat {
            randomX = CGFloat.random(min: (-size.width / 2) - 100, max: size.width + 200)
            randomY = CGFloat.random(min: (size.height / 2) - 100, max: (size.height/2) + 300)
        } while intersection.contains(CGPoint(x: randomX, y: randomY))
        let bottomX = CGFloat.random(min: -size.width / 2, max: size.width / 2)
        return (CGPoint(x: randomX, y: randomY), CGPoint(x: bottomX, y: (-size.height / 2) - 100))
    }

    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    
    func simpleRotate(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = atan2(direction.y, direction.x)
    }
    
    
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
            shipOne.dt = dt
            shipTwo.dt = dt
        } else {
            dt = 0
            shipOne.dt = dt
            shipTwo.dt = dt
        }
        lastUpdateTime = currentTime
        shipOne.lastUpdateTime = currentTime
        shipTwo.lastUpdateTime = currentTime
    }


}
