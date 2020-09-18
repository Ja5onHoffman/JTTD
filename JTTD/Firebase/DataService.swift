

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_SCORES = DB_BASE.child("scores")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_SCORES: DatabaseReference {
        return _REF_SCORES
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func lastLogin() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let df = DateFormatter()
        let date = Date()
        df.dateFormat = "MMM d, yyyy"
        let dateString = df.string(from: date)
        REF_USERS.child(userID).updateChildValues(["lastLogin": dateString])
    }
    
    func updateScore(_ score: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(userID).updateChildValues(["highScore": score])
    }
    
    func getScoreFor(user uid: String) -> Int {
        var score = -1
        if let uid = Auth.auth().currentUser?.uid {
            score = REF_SCORES.value(forKey: uid) as! Int
        }
        return score
    }
}
















