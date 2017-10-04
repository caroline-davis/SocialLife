//
//  UserVC.swift
//  SocialLife
//
//  Created by Caroline Davis on 3/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class UserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userName: UITextField!

    
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        // makes it so the user can move the image to the square they want it cropped at
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

    }

    @IBAction func addProfilePic(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            // uploading of the image and compressing it
            if let imgData = UIImageJPEGRepresentation(image, 0.2) {
                
                // the unique id
                let imgUid = NSUUID().uuidString
                
                // safety to tell code what type of file the img is
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                
                
                DataService.ds.REF_POST_PROFILE_PICS.child(imgUid).putData(imgData, metadata: metaData) { (metaData, error) in
                    if error != nil {
                        print("CAROL: Unable to upload image to firebase storage")
                    } else {
                        print("CAROL: Successfully uploaded image to firebase storage")
                        let downloadURL = metaData?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            self.postToFirebase(imgUrl: url)
                        }
                    }
                }
            }


        } else {
            print("CAROL: A valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func postToFirebase(imgUrl: String) {
        let userInfo: Dictionary<String, AnyObject> = [
            "profileImageUrl": imgUrl as AnyObject,
        ]
        let firebaseUser = DataService.ds.REF_CURRENT_USER
        firebaseUser.updateChildValues(userInfo)
    
    }

    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        // remove saved user id key
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("CAROL: ID removed from keychain \(keychainResult)")
        
        // log out of firebase
        try! Auth.auth().signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }


}
