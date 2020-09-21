//
//  UserData.swift
//  JTTD
//
//  Created by Jason Hoffman on 9/16/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

// Populate this file with user data when logged in to display on screen


import FirebaseFirestoreSwift

class User: Identifiable, Codable {
    
    static let sharedInstance = User()
    
    @DocumentID var id: String? = ""
    var name: String = ""
    var email: String = ""
    var highScore: Int = 0
    var lastLogin: String = ""
    var provider: String = ""
}
