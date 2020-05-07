//
//  UIViewController+Keyboard.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    func adjustBottom(constrain: NSLayoutConstraint, constantAdjustmentValue: CGFloat? = nil) {
        let notificationsCenter = NotificationCenter.default
        let defaultConstant = constrain.constant
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
        let safeAreaInsetsBottom = keyWindow?.safeAreaInsets.bottom ?? 0
        let willShow = notificationsCenter
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            .filterNil()
        
        let willHide = notificationsCenter
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in defaultConstant }
        
        willHide
            .subscribe(onNext: { [weak self] constant in
                UIView.animate(withDuration: 0.3) {
                    constrain.constant = constant
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: rx.disposeBag)
        
        willShow
            .subscribe(onNext: { [weak self] height in
                //This will be called if app goes to backgeound and comes back to foreground
                //Thus as a quick fix do not adjust constraint if it's already larger than the
                //Keyboard
                guard constrain.constant < (height - safeAreaInsetsBottom) else { return }
                UIView.animate(withDuration: 0.3) {
                    constrain.constant = height - safeAreaInsetsBottom + defaultConstant - (constantAdjustmentValue ?? 0)
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
