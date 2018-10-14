//
//  NavigationBar.swift
//  Testio
//
//  Created by Julius on 12/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

protocol NavigationBarDelegate: class {
    func onRightButtonTap()
}

@IBDesignable
class NavigationBar: ViewFromXib {
    weak var delegate: NavigationBarDelegate?
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBInspectable weak var logo: UIImage? {
        get {
            return logoImageView.image
        } set {
            logoImageView.image = newValue
        }
    }
    
    @IBInspectable weak var rightButtonImage: UIImage? {
        get {
            return rightButton.image(for: .normal)
        } set {
            rightButton.setImage(newValue, for: .normal)
        }
    }
    
    @IBAction func onRightButtonTap(_ sender: Any) {
        delegate?.onRightButtonTap()
    }
}
