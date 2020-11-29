//
//  LoginViewController+DataModelDelegate.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

extension LoginViewController: LoginDataModelDelegate {
    
    func didStartLoginOperation(dataModel: LoginDataModel) {
        showLoading()
    }
    
    func didFinishLoginOperation(dataModel: LoginDataModel) {
        hideLoading()
        AppDelegate.shared.logedInViewController()
    }
    
    func didFailLoginOperation(dataModel: LoginDataModel, message: String) {
        hideLoading()
        let alert = AlertControllerFactory.showAlert(title: "Login Failed!", message: message)
        present(alert, animated: true)
    }
}
