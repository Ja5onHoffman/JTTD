

import Foundation
import Firebase
import FirebaseFirestoreSwift

let DB_BASE = Firestore.firestore()

class DataService {
    static let instance = DataService()
    let loggedInUser = User.sharedInstance
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.collection("users")
    private var _REF_SCORES = DB_BASE.collection("score")
    
    var REF_BASE: Firestore {
        return _REF_BASE
    }
    
    var REF_USERS: CollectionReference {
        return _REF_USERS
    }
    
    var REF_SCORES: CollectionReference {
        return _REF_SCORES
    }
    
    func createDBUser(userData: User) {
        do {
            // setData creates custom userid vs createDocument
            try REF_USERS.document(userData.id!).setData(from: userData)
            lastLogin()
        } catch {
            print("Unable to create user")
        }
    }
    
    func getUsernameAndScore(forUID uid: String, completion: @escaping (_ name: String, _ score: Int) -> ()) {
        REF_USERS.document(uid).getDocument { (document, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if let doc = document {
                let name = doc.get("name") as! String
                let score = doc.get("highScore") as! Int
                completion(name, score)
            }
        }
    }
    

    func lastLogin() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let df = DateFormatter()
        let date = Date()
        df.dateFormat = "MMM d, yyyy"
        let dateString = df.string(from: date)
        REF_USERS.document(userID).updateData(["lastLogin": dateString])
    }
    
    func updateScore(_ score: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        REF_USERS.document(userID).updateData(["highScore": score])
        loggedInUser.highScore = score /* User score should change whenever object changes
         instead of udpating here */
    }
}
















