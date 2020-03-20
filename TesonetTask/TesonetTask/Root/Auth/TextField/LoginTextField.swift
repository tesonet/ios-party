//
//  LoginTextField.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class LoginTextField: UIView {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}
