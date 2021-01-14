//
//  InitialVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 5/23/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class InitalVC: UIViewController {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastGameLabel: UILabel!
    @IBOutlet weak var startButton: UIButton! 
    @IBOutlet weak var spacePlow: UILabel!
    @IBOutlet weak var scoreBG: UIView!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let loggedInUser = User.sharedInstance
    let fadeSegue = FadeSegueAnimator()
    let musicPlayer = MusicPlayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(popFields(_:)), name: .userLoaded, object: nil)
//        try! Auth.auth().signOut()
        spacePlow.layer.shadowColor = UIColor.darkGray.cgColor
        spacePlow.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        spacePlow.layer.shadowOpacity = 1.0
        scoreBG.layer.cornerRadius = 10.0
        scoreLabel.layer.zPosition = 100
        
        startButton.layer.cornerRadius = 5.0
        signoutButton.layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
//        musicPlayer.startBackgroundMusic("Alex Catana - Speed Of Light")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEWWILLAPPEAR")
        DataService.instance.lastLogin()
        animateShadow()
        toggleJustPlay()
    }

    @IBAction func start(_ sender: Any) {
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        guard let providerData = Auth.auth().currentUser?.providerData[0].providerID else { return }
        
        switch providerData {
        
        // This does nothing because always Firebase
        case "google.com":
            do {
                try Auth.auth().signOut()
                toggleAuthVC()
            } catch {
                print("Error signing out. Provider: \(providerData)")
            }

        default:
            do {
                try Auth.auth().signOut()
                toggleAuthVC()
            } catch {
                print("Error signing out. Provider: \(providerData)")
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
    }
    
    func toggleJustPlay() {
        signoutButton.isHidden = !signoutButton.isHidden
        loginButton.isHidden = !loginButton.isHidden
        
//        scoreBG.alpha = 1.0
        let label = UILabel(frame: CGRect(
                                x: scoreBG.frame.origin.x,
                                y: scoreBG.frame.origin.y,
                                width: scoreBG.frame.size.width,
                                height: scoreBG.frame.size.height))
        label.layer.name = "loginLabel"
        label.text = "Log in to record score"
        label.font = UIFont(name: "Zorque-Regular", size: 22.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.position = CGPoint(x: scoreBG.frame.size.width / 2, y: scoreBG.frame.size.height / 2)
        
        if scoreBG.subviews.contains(label) {
            label.removeFromSuperview()
            self.view.sendSubviewToBack(scoreBG)
        } else {
            scoreBG.addSubview(label)
            self.view.bringSubviewToFront(scoreBG)
        }
    }
    
    func wipeFields() {
        playerLabel.text = ""
        scoreLabel.text = ""
        lastGameLabel.text = ""
    }
    
    @objc func popFields(_ notification: NSNotification) {
        print("popfields")
        if let _ = Auth.auth().currentUser {
            playerLabel.text = loggedInUser.name
            scoreLabel.text = String(loggedInUser.highScore)
            lastGameLabel.text = loggedInUser.lastLogin // With email login logged in user isn't getting a lastLogin
        }
    }
    
    func toggleAuthVC() {
        let authVC = storyboard!.instantiateViewController(withIdentifier: "AuthVC")
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
    
    func animateShadow() {
        let color = CABasicAnimation(keyPath: "shadowColor")
        color.repeatCount = 5000.0
        color.duration = 5.0
        color.autoreverses = true
        color.fromValue = CGColor(red: 76.0 / 255, green: 0.0 / 255, blue: 153.0 / 255, alpha: 1.0)
        color.toValue = UIColor.red.cgColor
        spacePlow.layer.add(color, forKey: "shadowColor")
    }
    
    // for custom segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let gameView = segue.destination as? GameViewController
//        gameView?.transitioningDelegate = self
//        segue.perform()
//    }
    
//    @objc func gameOver(_ notification: NSNotification) {
//        print("gameover")
//        let gameOverVC = self.storyboard!.instantiateViewController(withIdentifier: "gameOverVC")
//        gameOverVC.modalPresentationStyle = .fullScreen
//        present(gameOverVC, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
//    }
}

extension Notification.Name {
    static let userLoaded = Notification.Name("userLoaded")
}

//extension InitalVC: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return fadeSegue
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil
//    }
//}
