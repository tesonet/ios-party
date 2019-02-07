//
//  LoginTextField.swift
//  Hwork
//
//  Created by Robert P. on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import UIKit

enum FieldType {
    case user
    case password
}

class LoginTextField: UITextField {
    
    struct LoginTextFieldConst {
        static let placeholderPadding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
        static let iconSize = CGSize(width: 10, height: 10)
        static let iconLeftMargin:CGFloat = 15.0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupByType(type:FieldType) {
        
        placeholder = type.getImageNameAndTitle().title
        addIcon(name: type.getImageNameAndTitle().image)
    }
    
    func addIcon(name:String) {
        let topMargin = (bounds.height - LoginTextFieldConst.iconSize.height)/2
        let img = UIImage(named: name)
        let imgView = UIImageView(frame: CGRect(x: LoginTextFieldConst.iconLeftMargin, y: topMargin, width: LoginTextFieldConst.iconSize.width, height: LoginTextFieldConst.iconSize.height))
        imgView.image = img
        addSubview(imgView)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: LoginTextFieldConst.placeholderPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 35, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 35, dy: 0)
    }

}


extension FieldType {
    
    func getImageNameAndTitle() -> (image:String, title:String) {
        switch self {
        case .user:
            return (image:"ico-username", "Username")
        case .password:
            return ("ico-lock", "Password")
        }
    }
}
