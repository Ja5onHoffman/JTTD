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
        
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir Next")
        gameOverLabel.position = CGPoint(x: 0, y: 200)
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontColor = .white
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.fontSize = 180
        gameOverLabel.alpha = 0.0
        gameOverLabel.zPosition = 1001
        background.addChild(gameOverLabel)

        let homeTexture = SKTexture(imageNamed: "button_home")
        let homeButton = ButtonNode(normalTexture: homeTexture, selectedTexture: homeTexture, disabledTexture: homeTexture)
        homeButton.position = CGPoint(x: 0, y: -400)
        homeButton.scale(to: CGSize(width: homeButton.size.width * 3, height: homeButton.size.height * 3))
        homeButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(goHome(_:)))
        background.addChild(homeButton)
        
        let fade = SKAction.fadeIn(withDuration: 1)
        let rotateR = SKAction.rotate(byAngle: -0.6, duration: 1.0)
        let rotateL = SKAction.rotate(byAngle: 0.6, duration: 1.0)
        let seq = SKAction.sequence([rotateR, rotateR.reversed(), rotateL, rotateL.reversed()])
        gameOverLabel.run(fade)
        gameOverLabel.run(SKAction.repeatForever(seq))

    }
    
    @objc func goHome(_ selector: Selector) {
        print("scene goHome called")
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
