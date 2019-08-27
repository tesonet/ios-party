//
//  LoginViewController.swift
//  testio
//
//  Created by Justinas Baronas on 14/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var token: Closures?
    private let loginView = LoginView()
    
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupLoginView()
    }
    
    
    // MARK: - Setup
    
    private func setupLoginView() {
        loginView.onLoginTap = { [weak self] in
            self?.onLoginTap()
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Keyboard cycle
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                loginView.moveContent(toHeight: keyboardSize.height / 3)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            loginView.moveContent(toHeight: 0)
        }
    }
    
    
    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        loginView.moveContent(toHeight: 0)
    }

}


// MARK: - Requests

extension LoginViewController {
    private func onLoginTap() {
        ServiceLayer.request(router: .getToken(username: "tesonet",
                                               password: "partyanimal"))
        { (result: Result<[String : String], Error>) in
            switch result {
            case .success(let token):
                guard let token = token[K.Credentials.token] else { return }
                let credentials = UserCredentials(username: "tesonet",
                                                  password: "partyanimal")
                Authentication.saveUser(credentials, withToken: token)

                self.userLoggenIn(with: credentials)
            case .failure:
                print(result)
            }
        }
    }
    
    private func userLoggenIn(with credentials: UserCredentials) {
        ServiceLayer.request(router: .getServersList) { (result: Result< [Server], Error>) in
            switch result {
            case .success(let servers):
                CoreDataManager.shared.save(servers)
                AppNavigator.shared.navigate(from: self, to: .serverListView(with: servers))
                
            case .failure:
                print(result)
            }
        }
        
    }
    
    
}
