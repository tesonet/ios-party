//
//  LoginViewController+DataModelDelegate.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

extension LoginViewController: LoginDataModelDelegate {
    
    func didStartLoginOperation(dataModel: LoginDataModel) {
        
    }
    
    func didFinishLoginOperation(dataModel: LoginDataModel) {
        
    }
    
    func didFailLoginOperation(dataModel: LoginDataModel, message: String) {
        let alert = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) // FIXME: move to dedicated place
    }
}
