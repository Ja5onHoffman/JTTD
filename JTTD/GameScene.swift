//
//  GameScene.swift
//  JTTD
//
//  Created by Jason Hoffman on 4/27/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
// 

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var background = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNext")
    let levelLabel = SKLabelNode(fontNamed: "AvenirNext")
    
    // Nodes
    var bgNode: SKNode!
    var fgNode: SKNode!
    var overlay: SKNode!
    var border: SKShapeNode!
    var catchLine: SKShapeNode!
    var catchLinePath: CGMutablePath!
    var laser: SKSpriteNode!
    var dotCount: Int = 0
    
    override func didMove(to view: SKView) {
        print("didMove")
        setupNodes()
        
//        debugDrawPlayableArea()
        self.physicsWorld.contactDelegate = self
//
//        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
//            self?.scaleDot()
//            }, SKAction.wait(forDuration: 1.0)])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        
        if let dot1 = fgNode.childNode(withName: "greenDot_\(dotCount - 1)") as? SKSpriteNode {
            greenDot(position: positionInScene)
        
            lineBetween(dot1: dot1, dot2: fgNode.childNode(withName: "greenDot_\(dotCount - 1)") as! SKSpriteNode)
        } else {
            greenDot(position: positionInScene)
        }
        
//        guard let touchedNode = self.nodes(at: positionInScene).first as? SKSpriteNode else { return }
//        if let dot = touchedNode.name {
//            if dot == "dot" {
//                removeDot(touchedNode)
//            }
//        }
        
        
        
//        if let _ = fgNode.childNode(withName: "laser") {
//            print("already there")
//        } else {
//            laser.centerRect = CGRect(x: 0.42857143, y: 0.57142857, width: 0.14285714, height: 0.14285714)
//            laser.anchorPoint = CGPoint(x: 0, y: 0.5)
//            laser.position = positionInScene
//            fgNode.addChild(laser)
//        }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let positionInScene = touch.location(in: self)
//        stretchLaserTo(positionInScene)
//    }
   
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let positionInScene = touch.location(in: self)
//        print(positionInScene)
//        guard let touchedNode = self.nodes(at: positionInScene).first as? SKSpriteNode else { return }
//        if let dot = touchedNode.name {
//            if dot == "dot" {
//                removeDot(touchedNode)
//            }
//        }
//        endLine(positionInScene)
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first
//    }
//
    
    func removeDot(_ dot: SKSpriteNode) {
        dot.removeFromParent()
    }
    
    // MARK: Setup
    func setupNodes() {
        let worldNode = childNode(withName: "World")!
        fgNode = worldNode.childNode(withName: "Foreground")
        bgNode = worldNode.childNode(withName: "Background")
    }
    
    func newLaser() -> SKSpriteNode {
        laser = SKSpriteNode(imageNamed: "laser")
        laser.centerRect = CGRect(x: 0.42857143, y: 0.57142857, width: 0.14285714, height: 0.14285714)
        laser.zPosition = 100
        return laser
    }
    
//    func backgroundNode() -> SKSpriteNode {
//        let backgroundNode = SKSpriteNode()
//        backgroundNode.anchorPoint = CGPoint.zero
//        backgroundNode.size = CGSize(width: 1125, height: 2436)
//        backgroundNode.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        backgroundNode.zPosition = 1
//        return backgroundNode
//    }
    
    
    func debugDrawPlayableArea() {
        guard let view = view else { return }
        let width = size.width
        let height = size.height
        border = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height))
        border.strokeColor = SKColor.red
        border.lineWidth = 4.0
        border.zPosition = 1000
    }
    
//    func debugDrawPlayableArea() {
//        guard let view = view else { return }
//        let width = size.width
//        let height = size.height
//        let shape = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
//        shape.strokeColor = SKColor.red
//        shape.lineWidth = 4.0
//        shape.zPosition = 1000
//        fgNode.addChild(shape)
//    }
    
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
        rotate(sprite: l, direction: direction)
        fgNode.addChild(l)
    }
    
    func stretchLaserTo(_ point: CGPoint) {
        let offset = point - laser.anchorPoint
        let length = offset.length()
        let direction = offset / CGFloat(length)
        
        
        rotate(sprite: laser, direction: direction)
    }
    
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = atan2(direction.y, direction.x)
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
    

    
//    func startLine(_ start: CGPoint) {
//        catchLine = SKShapeNode()
//        catchLinePath = CGMutablePath()
//        catchLinePath.move(to: start)
//        catchLine.path = catchLinePath
//        catchLine.zPosition = 10
//        catchLine.strokeColor = SKColor.red
//        catchLine.lineWidth = 10
//        fgNode.addChild(catchLine)
//    }
    
//    let offset = location - zombie.position
//    let length = offset.length()
//    let direction = offset / CGFloat(length)
    
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
    
    override func update(_ currentTime: TimeInterval) {
       
    }
    

}
