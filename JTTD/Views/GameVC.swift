
import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as! SKView? {
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.ignoresSiblingOrder = true
//            skView.showsPhysics = true
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.size = CGSize(width: 1125, height: 2436)
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }
        }
//        
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver(_:)), name: .gameOver, object: nil)
    }
    
    @objc func gameOver(_ notification: NSNotification) {
        let gameOverVC = self.storyboard!.instantiateViewController(withIdentifier: "GameOverVC")
        gameOverVC.modalTransitionStyle = .crossDissolve
        gameOverVC.modalPresentationStyle = .fullScreen
        present(gameOverVC, animated: true, completion: nil)
    }
}
