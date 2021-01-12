//
//  GameOverScene.swift
//  JTTD
//
//  Created by Jason Hoffman on 11/13/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameOver: SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = childNode(withName: "Background")!
//        background.zPosition = 1
        self.backgroundColor = .black
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "Zorque-Regular")
        gameOverLabel.position = CGPoint(x: 0, y: 500)
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontColor = .white
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.fontSize = 180
        gameOverLabel.alpha = 0.0
        gameOverLabel.zPosition = 1001

        gameOverLabel.physicsBody = SKPhysicsBody(circleOfRadius: 1.0)
        gameOverLabel.physicsBody?.affectedByGravity = true
        
    
        background.addChild(gameOverLabel)
        let gameOverLabelSize = gameOverLabel.calculateAccumulatedFrame()
        
        let labelFire = SKEmitterNode(fileNamed: "LabelFire")!
        labelFire.particlePositionRange = CGVector(dx: gameOverLabelSize.width, dy: 0)
        labelFire.position = CGPoint(x: 0, y: gameOverLabelSize.height - 60)
        gameOverLabel.addChild(labelFire)
        
        let fade = SKAction.fadeIn(withDuration: 1)
        let goHome = SKAction.afterDelay(2) {
            self.perform(#selector(self.goHome(_:)))
        }
        let seq = SKAction.sequence([fade, goHome])
        gameOverLabel.run(seq)
    }
    
    @objc func goHome(_ selector: Selector) {
        self.removeFromParent()
        self.view?.presentScene(nil)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .goHome, object: nil)
        }
    }
    
}

extension Notification.Name {
    static let goHome = Notification.Name("goHome")
}
