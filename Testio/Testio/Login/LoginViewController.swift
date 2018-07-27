//
//  LoginViewController.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, BindableType {
    
    typealias ViewModelType = LoginViewModel
    
    var viewModel: ViewModelType
    
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var logInButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    func bindViewModel() {
        
    }

}

extension LoginViewController {
    
    private func setupAppearance() {
        let usernamePlaceholder = NSLocalizedString("USERNAME_PLACEHOLDER", comment: "")
        usernameTextField.placeholder = usernamePlaceholder
        
        let usernameImage = #imageLiteral(resourceName: "ico-username")
        image(usernameImage, forTextField: usernameTextField)

        let passwordPlaceholder = NSLocalizedString("PASSWORD_PLACEHOLDER", comment: "")
        passwordTextField.placeholder = passwordPlaceholder
        setupButton()
        
        let passwordImage = #imageLiteral(resourceName: "ico-lock")
        image(passwordImage, forTextField: passwordTextField)
        
    }
    
    private func image(_ image: UIImage, forTextField textField: UITextField) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 13)
        imageView.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
        textField.leftView = imageView
    }
    
    private func setupButton() {
        let loginButtonTitle = NSLocalizedString("PERFORM_LOG_IN", comment: "")
        logInButton.setTitle(loginButtonTitle, for: .normal)
        logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.backgroundColor = Colors.actionColor
        logInButton.layer.cornerRadius = 5
    }
    
}
