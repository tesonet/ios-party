//
//  LoginFieldBuilder.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

struct LoginFieldFactory {
    static func makeLoginTextField(placeholder: String?, image: UIImage?) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        if let image = image {
            textField.leftViewMode = .always
            let imageView = UIImageView(image: image)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: imageView.bounds.width + (2*20), height: imageView.bounds.height))
            view.addSubview(imageView)
            imageView.frame.origin.x = 20
            textField.leftView = view
        }
        return textField
    }
}


