
//
//  Mothership.swift
//  JTTD
//
//  Created by Jason Hoffman on 9/19/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import Foundation
import SpriteKit

enum MothershipSettings {
    static var shipNum = 0
}

enum State {
   case normal, critical
}

enum BeamState {
    case health, tractor, none
}

class Mothership: SKSpriteNode, EventListenerNode {

    let mothership = SKSpriteNode(imageNamed: "mothership10")
    var health: Int = 100
    var healthBar: HealthBar!
    var state: State = .normal
    var beamState: BeamState = .none
    var gameOver = false
//    var beam: Beam!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        self.init(imageNamed: "mothership10")
        self.name = "mothership"
        self.zPosition = 100
        isPaused = false
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Mother
        physicsBody?.collisionBitMask = PhysicsCategory.None
        physicsBody?.contactTestBitMask = PhysicsCategory.Meteor
        drawBorder()
    }
    
    func didMoveToScene() {
        beginMovement()
        // ship on fire
//        let fire = SKEmitterNode(fileNamed: "BaseDamage")!
//        fire.position = CGPoint(x: 0, y: 0)
//        fire.zPosition = zPosition - 1
//        fire.alpha = 0.1
//        addChild(fire)
//        smokeTrail()

    }
    
    func beginMovement() {
        let leftUp = SKAction.moveBy(x: -400, y: 100, duration: 4.0)
        let leftDown = SKAction.moveBy(x: -400, y: -100, duration: 4.0)
        let rightUp = SKAction.moveBy(x: 400, y: 100, duration: 4.0)
        let rightDown = SKAction.moveBy(x: 400, y: -100, duration: 4.0)
        let seq = SKAction.sequence([leftUp, rightDown, rightUp, leftDown])
        let rep = SKAction.repeatForever(seq)
        run(rep)
    }
    
    func shipHit() {
        shakeShipByAmt(20)
        print(health)
        health -= 10
        if health > -10 {
            healthBar.decreaseHealth(by: health)
            showDamage(health)
            // lives, etc here
        } else if health <= 0 {
            explode()
            gameOver = true
        }
    }
    
    func showDamage(_ health: Int) {
        if health < 50 {
            state = .critical
            if let fire = childNode(withName: "fire") {
                fire.alpha += 0.2
            } else {
                let fire = SKEmitterNode(fileNamed: "BaseDamage")!
                fire.position = CGPoint(x: 0, y: 0)
                fire.zPosition = zPosition - 1
                fire.alpha = 0.1
                addChild(fire)
            }
        }
    }
    
    func cycleBeam(in time: TimeInterval) {
        beamState = .health
        let timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            let duration = Int.random(in: 2..<6)
            self.run(SKAction.sequence([
                SKAction.run { self.showHealthBeam() },
                SKAction.wait(forDuration: Double(duration)),
                SKAction.run { self.removeHealthBeam() }
            ]))
            
            print("Fired")
        }
    }
    
    func showHealthBeam() {
        
        guard let beam = SKSpriteNode(fileNamed: "Beam")?.childNode(withName: "BeamOverlay") as? SKSpriteNode else { return }
        
        beam.position = CGPoint(x: position.x, y: position.y + 250)
        beam.name = "beam"
        beam.isPaused = false
        beam.zPosition = zPosition + 1
        if let ring = beam.childNode(withName: "ring") as? SKSpriteNode {
            ring.physicsBody = SKPhysicsBody(circleOfRadius: ring.size.width / 3)
            ring.physicsBody?.affectedByGravity = false
            ring.physicsBody?.categoryBitMask = PhysicsCategory.Recharge
            ring.physicsBody?.collisionBitMask = PhysicsCategory.None
            ring.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
        }
        beam.move(toParent: self)
    }
    
    func removeHealthBeam() {
        beamState = .none
        if let b = childNode(withName: "beam") {
            b.run(SKAction.fadeOut(withDuration: 0.5)) {
                b.removeFromParent()
            }
        }
    }
    
    func showTractor() {
        beamState = .tractor
        if let tractor = SKSpriteNode(fileNamed: "Tractor")?.childNode(withName: "tractor") as? SKSpriteNode {
            tractor.position = CGPoint(x: position.x, y: position.y + 300)
            tractor.setScale(0.5)
            tractor.name = "tractor"
            tractor.isPaused = false
            tractor.zPosition = zPosition + 1
            tractor.move(toParent: self)
        }
    }
    
    func removeTractor() {
        childNode(withName: "tractor")?.removeFromParent()
    }
    
    func explode() {
        let particles = SKEmitterNode(fileNamed: "Poof")!
        particles.position = position
        particles.zPosition = 3
        let fg = self.parent
        fg?.addChild(particles)
        removeFromParent()
        particles.run(SKAction.removeFromParentAfterDelay(0.5))
        return
    }
    
    func drawBorder() {
        let borderRect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        let border = SKShapeNode(rect: borderRect)
        border.strokeColor = UIColor.red
        border.lineWidth = 5
        addChild(border)
    }

    func smokeTrail() {
        if let _ = childNode(withName: "smoke") {
            return
        } else {
            let trail = SKEmitterNode(fileNamed: "SmokeTrail")!
            trail.name = "smoke"
            trail.position = position
            trail.zPosition = zPosition - 1
            let fg = self.parent
            fg?.addChild(trail) // not sure why it only works this way
            run(SKAction.sequence([SKAction.wait(forDuration: 3.0),
                                   SKAction.run() {
                                    self.removeSmoke(trail)
                }
            ]))
        }
    }
    
    func removeSmoke(_ trail: SKEmitterNode) {
        trail.numParticlesToEmit = 1
        trail.run(SKAction.removeFromParentAfterDelay(1.0))
    }
    
    func shakeShipByAmt(_ amt: CGFloat) {
        self.removeAction(forKey: "shake")
        let amount = CGPoint(x: 0, y: -amt)
        let action = SKAction.screenShakeWithNode(self, amount: amount, oscillations: 10, duration: 0.5)
        run(action, withKey: "shake")
    }


}
