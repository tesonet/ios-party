//
//  AuthViewController.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, MainController {
    
    var type: MainControllerType
    let usernameViewModel = LoginTextFieldModel(type: .username)
    let passwordViewModel = LoginTextFieldModel(type: .password)
    let loginButtonModel = LoginButtonModel()
    let networkManager = AuthNetworkManager()
    let authManager = Bindings.shared.authManager
    
    
    init() {
        type = .auth
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setup() {
        view.add(model: usernameViewModel)
        view.add(model: passwordViewModel)
        view.add(model: loginButtonModel)
        
        loginButtonModel.delegate = self
    }
    
}

extension AuthViewController: LoginButtonModelDelegate {
    
    func loginAction() {
        guard let username = usernameViewModel.getTextFieldValue(),
            let password = passwordViewModel.getTextFieldValue() else {
            return
        }
        
        loginButtonModel.loading = true
        
        let params = ["username": username, "password": password];
        networkManager.login(params) { (result) in
            self.loginButtonModel.loading = false
            
            switch result {
            case .success(let response):
                self.authManager.saveAuthorizationToken(token: response.token)
                self.getRootController().changeRoot(type: .main)
            case .failure(let error):
                ShowWarning.showWarningWithString(error.localizedDescription)
            }
        }
    }
    
}
