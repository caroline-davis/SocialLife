//
//  FeedVCViewController.swift
//  SocialLife
//
//  Created by Caroline Davis on 6/09/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        // makes it so the user can move the image to the square they want it cropped at
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //**** the listener for changes in the firebase db ****
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print("CAROL: \(snapshot.value)")
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // to take the data from firebase and show it in the cells in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
        } else {
                cell.configureCell(post: post)
            return cell
            }
        } else {
            return PostCell()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("CAROL: A valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
 
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else {
            print("CAROL: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("CAROL: An image must be selected")
            return
        }
        
        // uploading of the image and compressing it
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            // the unique id
            let imgUid = NSUUID().uuidString
            
            // safety to tell code what type of file the img is
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("CAROL: Unable to upload image to firebase storage")
                } else {
                    print("CAROL: Successfully uploaded image to firebase storage")
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                }
            }
        }
        
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
