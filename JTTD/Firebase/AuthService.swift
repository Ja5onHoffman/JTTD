

//a2lnrJKwKvgU
import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    let loggedInUser = User.sharedInstance
    
    func registerUser(withEmail email: String, andPassword password: String, andName name: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
//            let addName = user.createProfileChangeRequest()
//            addName.displayName = name
//            addName.commitChanges { (error) in
//                if let e = error {
//                    print(e.localizedDescription)
//                }
//            }
            
            if let email = user.email, let provider = user.providerID as String? {
                self.loggedInUser.id = Auth.auth().currentUser?.uid
                self.loggedInUser.name = name
                self.loggedInUser.email = email
                self.loggedInUser.highScore = 0
                self.loggedInUser.provider = provider
            }
            
            DataService.instance.createDBUser(userData: self.loggedInUser)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            
            // Works better on main thread
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .userLoaded, object: nil)
            }
            
            loginComplete(true, nil)
        }
    }
}
