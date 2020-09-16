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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func start(_ sender: Any) {
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        if Auth.auth().currentUser?.providerID == "Firebase" {
            do {
                try Auth.auth().signOut()
                let authVC = storyboard!.instantiateViewController(withIdentifier: "AuthVC")
                present(authVC, animated: true)
            } catch {
                print("Sign out error")
            }
        } else if Auth.auth().currentUser?.providerID == "Google" {
            GIDSignIn.sharedInstance()?.signOut()
        }
        
    }
}
