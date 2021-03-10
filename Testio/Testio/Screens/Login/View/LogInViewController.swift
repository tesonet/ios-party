//
//  InfoListViewController.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

final class LogInViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private weak var usernameTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var loginButton: Button!
    
    var viewModel: LoginViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        usernameTextField.update(with: .username)
        passwordTextField.update(with: .password)
        
        usernameTextField.onEnterText = {
            self.handleLoginButtonAvailability()
        }
        
        passwordTextField.onEnterText = {
            self.handleLoginButtonAvailability()
        }
    }
    
    private func handleLoginButtonAvailability() {
        (usernameTextField.hasText && passwordTextField.hasText) ? loginButton.enable() : loginButton.disable()
    }
}

extension LogInViewController {
    
    @IBAction func login(_ sender: Any) {
        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @IBAction func onScreenTap(_ sender: Any) {
        view.endEditing(true)
    }
}
