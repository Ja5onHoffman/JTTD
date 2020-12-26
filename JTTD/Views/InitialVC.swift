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
    
    let loggedInUser = User.sharedInstance
    let fadeSegue = FadeSegueAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        try! Auth.auth().signOut()
        NotificationCenter.default.addObserver(self, selector: #selector(popFields(_:)), name: .userLoaded, object: nil)
        
        spacePlow.layer.shadowColor = UIColor.darkGray.cgColor
        spacePlow.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        spacePlow.layer.shadowOpacity = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataService.instance.lastLogin()
        animateShadow()
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
