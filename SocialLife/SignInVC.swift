//
//  ViewController.swift
//  SocialLife
//
//  Created by Caroline Davis on 31/07/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var pwdField: FancyField!
    @IBOutlet weak var emailField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // segues dont work in viewdid
        if let _ =  KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    


    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("CAROL: Email User authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("CAROL: Unable to authenticate with Firebase using email: \(error) ")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        } else {
                            print("CAROL Successfully authenticated with Firebase using email")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }

                        }
                        
                    })
                }
            })
        }
    }

    @IBAction func fbButtonTapped(_ sender: AnyObject) {
        
        // to get read only info eg, the email address from the persons fb page
        // all of this is from  the fb documentation 
        // (https://developers.facebook.com/docs/swift/login#custom-login-button)
        
        let facebookLogin = LoginManager()
        facebookLogin.logIn([ .email], viewController: self) { loginResult in
        
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                // User succesfully logged in. Contains granted, declined permissions and access token.
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)

            }
        }
        
    }
    // link the fb log in with firebase authentication
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error != nil) {
                print("Unable to autheticate with firebase - \(error)")
            } else {
                print("Successfully authenticated with firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
                
            }
        }
    }
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("CAROl: Data saved to keychain\(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}

