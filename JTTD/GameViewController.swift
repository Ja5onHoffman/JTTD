
import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        if let skView = self.view as! SKView? {
            skView.showsFPS = true
            skView.showsNodeCount = true
//            skView.ignoresSiblingOrder = true
            skView.showsPhysics = true
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.size = CGSize(width: 1125, height: 2436)
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }
        }
    }
}
