//
//  InputView.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

@objc
protocol InputViewReturnDelegate: AnyObject {
  func inputViewDidReturn(_: InputView)
}

/**
 An input view that follows the design of the app, including displaying an icon.
 This view does **not** support frame resizing after initialization.
 */
@IBDesignable
class InputView: UIView {

  let iconView = UIImageView()
  let field = UITextField()

  @IBInspectable
  var icon: UIImage? {
    get { return iconView.image }
    set { iconView.image = newValue }
  }

  @IBInspectable
  var placeholder: String? {
    get { return field.placeholder }
    set { field.placeholder = newValue }
  }

  /// When set, the return key will display "next", and will activate the specified input when tapped.
  /// Otherwise the return key will display "go".
  @IBOutlet weak var nextInput: InputView? {
    didSet { field.returnKeyType = (nextInput == nil) ? .go : .next }
  }

  /// If no `nextInput` specified, this delegate will be notified when the return key was tapped.
  @IBOutlet weak var returnDelegate: InputViewReturnDelegate?

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    didInit(bounds.size)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    didInit(frame.size)
  }

  fileprivate func didInit(_ initialSize: CGSize) {

    layer.cornerRadius = 5

    field.delegate = self
    field.returnKeyType = .go
    field.font = .systemFont(ofSize: 14)
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.smartDashesType = .no
    field.smartInsertDeleteType = .no
    field.smartQuotesType = .no
    field.spellCheckingType = .no

    var size = initialSize
    if size.width <= 0 { size.width = 210 }
    if size.height <= 0 { size.height = 40 }

    iconView.frame = CGRect(x: 13, y: (size.height - 10) / 2, width: 10, height: 10)
    field.frame = CGRect(x: 36, y: 0, width: size.width - 36, height: size.height)
    addSubview(iconView)
    addSubview(field)

  }

}

extension InputView: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let anotherInput = nextInput {
      anotherInput.field.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
      returnDelegate?.inputViewDidReturn(self)
    }
    return false
  }

}

final class UsernameInput: InputView {

  override func didInit(_ initialSize: CGSize) {
    super.didInit(initialSize)
    field.textContentType = .username
  }

}

final class PasswordInput: InputView {

  override func didInit(_ initialSize: CGSize) {
    super.didInit(initialSize)
    field.textContentType = .password
  }

}
