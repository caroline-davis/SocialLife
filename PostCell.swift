//
//  PostCell.swift
//  SocialLife
//
//  Created by Caroline Davis on 12/09/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
        @IBOutlet weak var profileImg: UIImageView!
        @IBOutlet weak var userName: UILabel!
        @IBOutlet weak var postImg: UIImageView!
        @IBOutlet weak var caption: UITextView!
        @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //if you set a default value then like nil here then if you dont put the param in its ok
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("CAROL: Unable to download image from firebase storage")
                } else {
                    print("CAROL: image downloaded from firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)

                        }
                    }
                }
            })
        }
    }
}
