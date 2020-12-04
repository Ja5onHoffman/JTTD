//
//  GameOverVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 11/2/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameOverVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as! SKView? {
            skView.showsFPS = true
            skView.showsNodeCount = true
//            skView.ignoresSiblingOrder = true
//            skView.showsPhysics = true
            if let scene = SKScene(fileNamed: "GameOver") {
                scene.size = CGSize(width: 1125, height: 2436)
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)

            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(mainMenu(notification:)), name: .goHome, object: nil)
    }
    
    
    @objc func mainMenu(notification: Notification) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .userLoaded, object: nil) // Reloads user info
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(identifier: "InitialVC")
        self.present(initialVC, animated: true, completion: nil)
    }
}


