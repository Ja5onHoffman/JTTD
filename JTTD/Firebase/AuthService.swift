

//a2lnrJKwKvgU
import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    let loggedInUser = User.sharedInstance
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
            if let name = user.displayName, let email = user.email, let provider = user.providerID as String? {
                self.loggedInUser.id = Auth.auth().currentUser?.uid
                self.loggedInUser.name = name
                self.loggedInUser.email = email
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
            loginComplete(true, nil)
        }
    }
}
