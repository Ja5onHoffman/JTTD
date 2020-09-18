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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Called if presenting view controller is full screen
        if Auth.auth().currentUser != nil {
            // Not great but works for email sign in 
            dismiss(animated: true, completion: nil)
        }
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let navigationController = segue.destination as! UINavigationController
//        let modal = navigationController.topViewController
//        navigationController.presentationController?.delegate = modal as! UIAdaptivePresentationControllerDelegate
//
//    }
    
}
