//
//  UIKeyboardViewController.swift
//  Tesonet
//

import UIKit

class UIKeyboardViewController: UIViewController {
    var originalConstraint: CGFloat = 0.0
    @IBOutlet var bottomOffsetConstraint: NSLayoutConstraint! {
        didSet {
            originalConstraint = bottomOffsetConstraint.constant
        }
    }
    var firstResponder: UIView? {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? getFirstResponder(view) : nil
    }
    private var tapGesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        if let tapGesture = tapGesture {
            view.addGestureRecognizer(tapGesture)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    private func getFirstResponder(_ view: UIView) -> UIView? {
        guard !view.isFirstResponder else {
            return view
        }
        for subview in view.subviews {
            if let responder = getFirstResponder(subview) {
                return responder
            }
        }
        return nil
    }

    @objc private func didTapOutside() {
        view.endEditing(true)
    }

    @objc private func addKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func removeKeyboardObservers() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        let keyboardHeight = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0.0
        bottomOffsetConstraint.constant = originalConstraint + keyboardHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0.0
        bottomOffsetConstraint.constant = originalConstraint + keyboardHeight
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomOffsetConstraint.constant = originalConstraint
    }
}
