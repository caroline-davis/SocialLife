//
//  DataService.swift
//  SocialLife
//
//  Created by Caroline Davis on 14/09/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import Firebase

// this contains the URL of the root of the database (this is taken from GoogleService.plist file)
let DB_BASE = Database.database().reference()

let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB refereneces
    private var _REF_BASE = DB_BASE
    // (this is one child down from the main database ref on firebase database)
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
    // (post pics is the folder name
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    // the globally accessible vars computed properties
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
  
    
}










