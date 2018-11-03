//
//  ViewController_ext.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/3/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func textFieldsValid(inView: UIView) -> Bool {
        
        for subview in view.subviews {
            if let textField = subview as? UITextField {
                debugPrint("Found subviews!")
                if textField.text == "" {
                    return false
                }
            }
        }
        return true
    }
    
    func defaultErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
