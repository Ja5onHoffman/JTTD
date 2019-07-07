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
        self.physicsWorld.contactDelegate = self
//
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
            self?.meteor()
            }, SKAction.wait(forDuration: 2.0)])))
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
            }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        print("TOUCHES")
        laser.removeFromParent()
        
        if shipOne.moved {
            shipTwo.move(to: positionInScene, speed: 0.3) {
                self.shipTwo.rotate(directionOf: self.shipOne.position)
                self.shipOne.rotate(directionOf: self.shipTwo.position)
                self.shipOne.swapMove()
                self.lineBetween(firstSprite: self.shipOne, secondSprite: self.shipTwo)
            }
        } else {
            if let l = self.laser {
                l.removeFromParent()
            }
            shipOne.move(to: positionInScene, speed: 0.3, completion: nil)
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
        laser = newLaser()
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
        
        shipTwo = SKSpriteNode(fileNamed: "TestShip")?.childNode(withName: "basicShip") as? TestShip
        shipTwo.setScale(1)
        shipTwo.position = CGPoint(x: 100, y: 0)
    
        shipOne.move(toParent: fgNode)
        shipTwo.move(toParent: fgNode)
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
        let l = newLaser()
        l.xScale = length / laser.size.width
        l.yScale = CGFloat(4.0 / (l.xScale).squareRoot()) // This isn't great but work
        simpleRotate(sprite: l, direction: direction)
        l.position = CGPoint(midPointBetweenA: firstSprite.position, andB: secondSprite.position)
        fgNode.addChild(l)
    }
    
    
    func laserFrom(firstShip: SKSpriteNode, to secondShip: SKSpriteNode) {
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
    
    func meteor() {
        let num = Int.random(in: 1..<5)
        let meteor = SKSpriteNode(imageNamed: "meteor\(num)")
        meteor.name = "meteor"
        meteor.zPosition = 100
        meteor.setScale(CGFloat.random(in: 0.5..<2))
        meteor.position = meteorPosition()
        
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 2)
        meteor.physicsBody?.affectedByGravity = true
        if meteor.position.x < -size.width / 2 {
            let force = SKAction.applyForce(CGVector(dx: meteor.size.width, dy: 0), duration: 3)
            meteor.run(force)
        } else if meteor.position.x > size.width / 2 {
            let force = SKAction.applyForce(CGVector(dx: -meteor.size.width, dy: 0), duration: 3)
            meteor.run(force)
        }
        
        fgNode.addChild(meteor)
    }

    
    func meteorPosition() -> CGPoint {
        let theZone = CGRect(x: (-size.width / 2) - 200, y: (size.height / 2) - 200, width: size.width + 400, height: 400)
        let topView = CGRect(x: -size.width / 2, y: (size.height/2) - 200, width: size.width, height: 200)
        let intersection = theZone.intersection(topView) // could just use topView

//        let randomX = CGFloat.random(min: (-size.width / 2) - 200, max: size.width + 400)
//        let randomY = CGFloat.random(min: (size.height / 2) - 200, max: (size.height/2) + 200)
        
        var randomX: CGFloat
        var randomY: CGFloat
        repeat {
            randomX = CGFloat.random(min: (-size.width / 2) - 200, max: size.width + 400)
            randomY = CGFloat.random(min: (size.height / 2) - 200, max: (size.height/2) + 200)
        } while intersection.contains(CGPoint(x: randomX, y: randomY))
        return CGPoint(x: randomX, y: randomY)
    }
    
    // MARK: Animation
    
    func moveShipToward(location: CGPoint) {
        let offset = location - shipOne.position
        let length = offset.length()
        let direction = offset / CGFloat(length)
        velocity = direction * 700
        let moveAction = SKAction.move(to: location, duration: 0.5)
        shipOne.run(moveAction)
    }
    
    
    func move(ship: SKSpriteNode, toward location: CGPoint, completion: () -> Void?) {
        ship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let moveAction = SKAction.move(to: location, duration: 0.3)
        ship.run(moveAction)
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
