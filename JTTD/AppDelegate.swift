//
//  AppDelegate.swift
//  JTTD
//
//  Created by Jason Hoffman on 4/27/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    static let loggedInUser = User.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        let user = Auth.auth().currentUser
        if user == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let authVC = storyboard.instantiateViewController(withIdentifier: "AuthVC")
            authVC.modalPresentationStyle = .fullScreen
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(authVC, animated: true, completion: nil)
        } else {
            DB_BASE.collection("users").document(String(describing: user!.uid)).getDocument { (document, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    if let doc = document {
                        AppDelegate.loggedInUser.name = doc.get("name") as! String
                        AppDelegate.loggedInUser.highScore = doc.get("highScore") as! Int
                        AppDelegate.loggedInUser.lastLogin = doc.get("lastLogin") as! String
                        NotificationCenter.default.post(name: .userLoaded, object: nil)
                    }
                }
            }
        }
        
        return true
    }
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("GID sign in called")
        if let error = error {
            print("Google sign in error \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Google sign in error \(error.localizedDescription)")
            } else {
                guard let user = authResult?.user else {
                    print("No user created")
                    return
                }
            
                if let name = user.displayName, let email = user.email, let provider = user.providerID as String? {
                    AppDelegate.loggedInUser.id = user.uid
                    print("UserID: \(user.uid)")
                    AppDelegate.loggedInUser.name = name
                    AppDelegate.loggedInUser.email = email
                    AppDelegate.loggedInUser.provider = provider
                    
                    // Bad solution
                    let df = DateFormatter()
                    let date = Date()
                    df.dateFormat = "MMM d, yyyy"
                    let dateString = df.string(from: date)
                    AppDelegate.loggedInUser.lastLogin = dateString
                    
                    NotificationCenter.default.post(name: .userLoaded, object: nil)
                }
                                
                DB_BASE.collection("users").document(user.uid).getDocument { (user, error) in
                    if user!.exists {
                        print("user exists")
                    } else {
                        print("user created")
                        DataService.instance.createDBUser(userData: AppDelegate.loggedInUser)
                    }
                }
                
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

