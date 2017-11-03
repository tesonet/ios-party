//
//  ResponderRevealingScrollView.swift
//  pulse
//
//  Created by Adomas on 13/05/2017.
//  Copyright © 2017 Adomas Nosalis. All rights reserved.
//

import UIKit

class ResponderRevealingScrollView: UIScrollView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        contentInset = .zero
    }
}
