//
//  FancyField.swift
//  SocialLife
//
//  Created by Caroline Davis on 1/08/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // the bounds of the textfield -- makes it go in 10 on the side
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //will do the same when u start editing it
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
