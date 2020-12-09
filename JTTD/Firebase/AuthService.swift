

//a2lnrJKwKvgU
import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    let loggedInUser = User.sharedInstance
    let dataService = DataService.instance
    
    func registerUser(withEmail email: String, andPassword password: String, andName name: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
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
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                loginComplete(false, error)
                return
            }
            
            // get username and score? 
            self.dataService.getUsernameAndScore(forUID: user.uid) { (name, score) in
                self.loggedInUser.id = user.uid
                self.loggedInUser.name = name
                self.loggedInUser.email = user.email!
                self.loggedInUser.highScore = score
                self.loggedInUser.provider = user.providerID
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userLoaded, object: nil)
                }
            }

            
            loginComplete(true, nil)
        }
    }
}
