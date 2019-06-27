//
//  LoginVC.swift
//  JTTD
//
//  Created by Jason Hoffman on 5/21/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @IBAction func signIn(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!) { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, userCreationComplete: { (success, regError) in
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
    }
    
}
