//
//  GameOverVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 11/2/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI

class GameOverVC: UIViewController {
    
    override func viewDidLoad() {
        let gameOverLabel = UILabel()
        gameOverLabel.text = "Game Over"
        gameOverLabel.center = CGPoint(x: 0, y: 0)
        gameOverLabel.textAlignment = .center
        gameOverLabel.textColor = UIColor.red
        gameOverLabel.font = UIFont(name: "Avenir Next", size: 100.0)
        view.addSubview(gameOverLabel)
        
        let homeButtonImage = UIImage(named: "button_home")
        let homeButton = UIButton(type: .custom)
        homeButton.setImage(homeButtonImage, for: .normal)
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        self.view.addSubview(homeButton)
    }
    
    @objc func goHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(identifier: "intialVC")
        self.present(initialVC, animated: true, completion: nil)
    }
}


