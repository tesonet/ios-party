//
//  BaseViewController.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import UIKit

class BaseController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedOut), name: Notification.Name.UserLoggedOut, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func userLoggedOut() {
        openLoginView()
    }
    
    func openLoginView() {
        let storyboard = UIStoryboard.main
        guard let controller = storyboard.instantiateInitialViewController() else {
            return
        }
        present(controller, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func addBackground() {
        let background = UIImageView(image: UIImage(named: "background"))
        background.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        background.contentMode = .scaleAspectFill
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
