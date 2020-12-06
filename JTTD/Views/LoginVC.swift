//
//  LoginVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 5/21/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameFields: UIStackView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    
    let user = User.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signInButtonPressed(_sender: Any) {
        signIn()
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.signInButton.isHidden = true
            self.usernameFields.isHidden = false
            self.submitButton.isHidden = false
            self.registerButton.isHidden = true
            self.accountLabel.isHidden = true
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        signIn() // signIn() also captures names for new users
    }
    
    
    // Log in or sign up
    // loginuser called but not sign up
   func signIn() {
        if emailTextField.text != nil && passwordTextField.text != nil && nameTextField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!) { (success, loginError) in
                if success {
                    print("Login success!")
                    
                    self.dismiss(animated: true, completion: nil)
                } else {
                    guard let email = self.emailTextField.text, let pass = self.passwordTextField.text, let name = self.nameTextField.text else {
                        print(String(describing: loginError?.localizedDescription))
                        return
                    }
                    self.signUp(with: email, andPassword: pass, andName: name)
                    print("creating new user")
                }
            }
        }
    }
    
    func signUp(with email: String, andPassword password: String, andName name: String) {
        AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, andName: name, userCreationComplete: { (success, regError) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, loginComplete: { (success, nil) in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                print(String(describing: regError?.localizedDescription))
            }
        })
        
        
    }
    
}
