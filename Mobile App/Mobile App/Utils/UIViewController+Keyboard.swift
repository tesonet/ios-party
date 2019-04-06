//
//  UIViewController+Keyboard.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    func adjustCenter(constrain: NSLayoutConstraint, distanceToBottom: CGFloat) {
        let notificationsCenter = NotificationCenter.default
        
        let willShow = notificationsCenter
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            .filterNil()
            .map { keyboadHeight -> CGFloat in
                guard keyboadHeight > distanceToBottom else { return 0 }
                return distanceToBottom - keyboadHeight - 24
            }
        
        let willHide = notificationsCenter
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        willHide
            .subscribe(onNext: { constant in
                UIView.animate(withDuration: 0.3) {
                    constrain.constant = constant
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: rx.disposeBag)
        
        willShow
            .subscribe(onNext: { height in
                UIView.animate(withDuration: 0.3) {
                    constrain.constant = height
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    ///Keyboard dismissal on tap
    func dismissKeyboardOnTap(cancelsTouchesInView: Bool = true) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
