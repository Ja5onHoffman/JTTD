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

class AuthVC: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var spacePlow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        spacePlow.layer.shadowColor = UIColor.darkGray.cgColor
        spacePlow.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        spacePlow.layer.shadowOpacity = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Called if presenting view controller is full screen
        if Auth.auth().currentUser != nil {
            // Not great but works for email sign in 
            dismiss(animated: true, completion: nil)
        }
        animateShadow()
    }
    
    @IBAction func emailSignIn(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")  else { return }
        if (Auth.auth().currentUser != nil) {
            print("Already logged in")
        } else {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
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
    
    func animateShadow() {
        let color = CABasicAnimation(keyPath: "shadowColor")
        color.repeatCount = 5000.0
        color.duration = 5.0
        color.autoreverses = true
        color.fromValue = CGColor(red: 76.0 / 255, green: 0.0 / 255, blue: 153.0 / 255, alpha: 1.0)
        color.toValue = UIColor.red.cgColor
        spacePlow.layer.add(color, forKey: "shadowColor")
    }
    
}
