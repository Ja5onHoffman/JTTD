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
    
    let loggedInUser = User.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.lastLogin()
        NotificationCenter.default.addObserver(self, selector: #selector(popFields(_:)), name: .userLoaded, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    
    
    @IBAction func start(_ sender: Any) {
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        guard let providerData = Auth.auth().currentUser?.providerData[0].providerID else { return }
        
        switch providerData {
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
}


extension Notification.Name {
    static let userLoaded = Notification.Name("userLoaded")
}
