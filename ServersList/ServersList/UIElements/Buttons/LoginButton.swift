//
//  LoginButton.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 22/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    let corner_radius : CGFloat =  5.0

    /*
     * Draws login button with rounded corners and fixed height
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.frame.size.height = 50.0
        
        self.layer.cornerRadius = corner_radius
        self.clipsToBounds = true
    }

}
