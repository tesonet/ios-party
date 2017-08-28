//
//  LoginViewController.swift
//  ios-party
//
//  Created by Adomas on 10/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: ResponderRevealingScrollView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    private let authentication = Authentication()
    private let keychainPassword = KeychainPassword()
    private var isLoading: Bool! {
        didSet {
            loadingView.isHidden = !isLoading
            scrollView.isHidden = isLoading
            if isLoading {
                loadingImageView.startRotating()
            } else {
                loadingImageView.stopRotating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        guard let username = UserDefaults.standard.string(forKey: Keys.usernameKey) else {
            return
        }
        do {
            let password = try keychainPassword.read()
            login(username: username, password: password)
        } catch {
            UserDefaults.standard.set(nil, forKey: Keys.usernameKey)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLoading = false
    }
    
    @IBAction func loginPressed() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        view.endEditing(true)
        
        isLoading = true
        login(username: username, password: password)
    }
    
    private func setupUI() {
        usernameContainerView.layer.cornerRadius = 2
        passwordContainerView.layer.cornerRadius = 2
        loginButton.layer.cornerRadius = 2
    }
    
    private func presentAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    private func login(username: String, password: String) {
        authentication.login(username: username, password: password, completion: { errorMessage in
            if let message = errorMessage {
                self.isLoading = false
                self.presentAlert(withMessage: message)
            } else {
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                do {
                    try self.keychainPassword.save(password)
                    UserDefaults.standard.set(username, forKey: Keys.usernameKey)
                } catch {
                }
                self.getServerList()
            }
        })
    }
    
    private func getServerList() {
        let serversModel = ServerListModel()
        serversModel.getServerList() { servers, error in
            self.isLoading = false
            self.navigationController?.present(ServersListViewController(model: serversModel), animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Loader view helper

extension UIView {
    func startRotating() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotating() {
        layer.removeAnimation(forKey: "rotationAnimation")
    }
}
