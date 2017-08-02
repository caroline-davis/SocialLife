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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        }
    }

}

