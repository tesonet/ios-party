//
//  KeyboardSafeAreaViewController.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

/**
 This view controller insets the additional safe area insets whenever the keyboard is displayed.
 */
class KeyboardSafeAreaViewController: UIViewController {

  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrame),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil)
    super.viewWillAppear(animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil)
  }

  @objc
  func keyboardWillChangeFrame(notification: Notification) {

    // get new frame of keyboard

    guard let info = notification.userInfo else { return }
    guard let endFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

    // get animation properties, or use some defaults

    let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
    let duration = info[durationKey] as? TimeInterval ?? 0

    let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
    let curveID = info[curveKey] as? UInt ?? UIView.AnimationOptions.curveEaseOut.rawValue
    let curve = UIView.AnimationOptions(rawValue: curveID)

    // apply the new insets

    let keybaordFrame = view.convert(endFrame, from: nil)
    let layoutFrame = view.safeAreaLayoutGuide.layoutFrame
    let existingInset = additionalSafeAreaInsets.bottom
    let newInset = layoutFrame.maxY + existingInset - keybaordFrame.minY

    UIView.animate(withDuration: duration, delay: 0, options: curve, animations: {
      self.additionalSafeAreaInsets.bottom = newInset
      self.view.layoutIfNeeded()
    })

  }

}
