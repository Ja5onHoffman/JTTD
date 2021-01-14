//
//  AuthVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 5/22/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//  You can't have insight without focus 

import UIKit
import GoogleSignIn
import Firebase


class AuthVC: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var spacePlow: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var buttonBG: UIView!
    @IBOutlet weak var buttonStack: UIStackView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        spacePlow.layer.shadowColor = UIColor.darkGray.cgColor
        spacePlow.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        spacePlow.layer.shadowOpacity = 1.0
        
        emailButton.layer.cornerRadius = 5.0
        playButton.layer.cornerRadius = 5.0
        signInButton.layer.cornerRadius = 5.0
        // buttonBG wants to go to front
        self.view.bringSubviewToFront(buttonStack)
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
        
        print("Email sign in")
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func justPlay(_ sender: Any) {
        let gameVC = storyboard?.instantiateViewController(identifier: "GameVC")
        present(gameVC!, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        
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
