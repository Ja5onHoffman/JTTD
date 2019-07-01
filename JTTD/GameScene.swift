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
        print("didMove")
        setupNodes()
        basicShips()
//        self.physicsWorld.contactDelegate = self
//
//        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
//            self?.scaleDot()
//            }, SKAction.wait(forDuration: 1.0)])))
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        
        if shipOne.moved {
            shipTwo.move(to: positionInScene, speed: 0.5)
            shipOne.moved = !shipOne.moved
        } else {
            shipOne.move(to: positionInScene, speed: 0.5)
        }
    }

    
//    func sceneTouched(location: CGPoint) {
//        lastTouchLocation = location
//        moveOne(velocity: location)
//        moveTwo(velocity: location)
//    }
    
    // MARK: Setup
    func setupNodes() {
        let worldNode = childNode(withName: "World")!
        fgNode = worldNode.childNode(withName: "Foreground")
        bgNode = worldNode.childNode(withName: "Background")
        background = bgNode.childNode(withName: "background") as? SKSpriteNode
    }
    
    func newLaser() -> SKSpriteNode {
        laser = SKSpriteNode(imageNamed: "laser")
//        laser.size = CGSize(width: 10, height: 10)
        laser.centerRect = CGRect(x: 0.42857143, y: 0.57142857, width: 0.14285714, height: 0.14285714)
        laser.zPosition = 100
        return laser
    }
    
    func basicShips() {
        shipOne = SKSpriteNode(fileNamed: "TestShip")?.childNode(withName: "basicShip") as? TestShip
        shipOne.setScale(1)
        shipOne.position = CGPoint(x: -50, y: 0)
        
        shipTwo = SKSpriteNode(fileNamed: "TestShip")?.childNode(withName: "basicShip") as? TestShip
        shipTwo.setScale(1)
        shipTwo.position = CGPoint(x: 50, y: 0)
        

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
    
    func lineBetween(dot1: SKSpriteNode, dot2: SKSpriteNode) {
        let offset = dot1.position - dot2.position
        let length = offset.length()
        let direction = offset / CGFloat(length)
        let l = newLaser()
        l.xScale = length / laser.size.width
        l.position = CGPoint(midPointBetweenA: dot1.position, andB: dot2.position)
//        rotate(sprite: l, direction: direction)
        fgNode.addChild(l)
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

    
    func endLine(_ end: CGPoint) {
        catchLinePath.addLine(to: end)
        catchLine.path = catchLinePath
    }
    
    func drawLine(_ start: CGPoint, _ end: CGPoint) {
        catchLine = SKShapeNode()
        catchLinePath = CGMutablePath()
        catchLinePath.move(to: start)
        catchLine.path = catchLinePath
        catchLine.zPosition = 10
        catchLine.strokeColor = SKColor.red
        catchLine.lineWidth = 10
        
//        let offset = start - end
//        let length = offset.length()
//        let direction = offset / CGFloat(length)
        catchLinePath.addLines(between: [start, end])
        fgNode.addChild(catchLine)
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
    
    
    func move(ship: SKSpriteNode, toward location: CGPoint) {
        let moveAction = SKAction.move(to: location, duration: 0.5)
        ship.run(moveAction)
    }
    
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
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
