//
//  PostCell.swift
//  SocialLife
//
//  Created by Caroline Davis on 12/09/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
        @IBOutlet weak var profileImg: UIImageView!
        @IBOutlet weak var userName: UILabel!
        @IBOutlet weak var postImg: UIImageView!
        @IBOutlet weak var caption: UITextView!
        @IBOutlet weak var likesLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
