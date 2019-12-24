//
//  AuthVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 5/22/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class AuthVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    @IBAction func emailSignIn(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true) {
            if (Auth.auth().currentUser != nil) {
                let gameVC = self.storyboard?.instantiateViewController(identifier: "GameView")
                self.present(gameVC!, animated: true, completion: nil)
            } else {
                print("Not logged in")
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func justPlay(_ sender: Any) {
        let gameVC = storyboard?.instantiateViewController(identifier: "GameView")
        present(gameVC!, animated: true, completion: nil)
    }
    
    @IBAction func facebookSignIn(_ sender: Any) {
        
    }
    
}
