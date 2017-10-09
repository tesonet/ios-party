//
//  ContainerViewControllerPresenter.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa
import KeychainSwift

class ContainerViewControllerPresenter: NSObject {
	
    internal var username : String? {
        let keychain = KeychainSwift()
        return keychain.get(Constants.userKey)
    }
    
    private var token : String? {
        let keychain = KeychainSwift()
        return keychain.get(Constants.tokenKey)
    }
    
    internal func didRequestLogOut(vc: ContainerViewController) {
        if let topController = vc.childViewControllers.first {
            let keychain = KeychainSwift()
            keychain.delete(Constants.userKey)
            keychain.delete(Constants.tokenKey)
            topController.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
	}
        
    internal func containerVCdidRequestLogin(vc: ContainerViewController, username: String, password: String) {
        if let topController = vc.childViewControllers.first {
            topController.performSegue(withIdentifier: "loadingSegue", sender: self)
        }
        
        _ = NetworkingManager.login(userName: username, password: password)
        {[weak self] (outUserModel, outError) in
            if let error = outError {
                self?.showLoginAlert(error:error, vc: vc, name: username, password: password)
                return
            }
            
            if let userModel = outUserModel {
                let keychain = KeychainSwift()
                keychain.set(userModel.username, forKey: Constants.userKey)
                keychain.set(userModel.token, forKey: Constants.tokenKey)
                
                DispatchQueue.main.async {
                    if let topController = vc.childViewControllers.first {
                        topController.performSegue(withIdentifier: "listViewControllerSegue", sender: self)
                    }
                }
            }
        }
    }
    
    private func showLoginAlert(error:Error, vc:ContainerViewController, name:String, password:String) {
        var message : String
        if error is ServerError {
            message = (error as! ServerError).description()
        } else {
            message = (error as NSError).localizedDescription
        }
        
        DispatchQueue.main.async {
            if let topController = vc.childViewControllers.first {
                topController.performSegue(withIdentifier: "loadingToLoginSegua", sender: self)
            }
            
            let result = AlertUtil.showInformationalAlert(title:"Error", text: message,
                buttonTitles: ["Try again", "Cancel"])
            switch result {
                case NSAlertFirstButtonReturn:
                    self.containerVCdidRequestLogin(vc: vc, username: name, password: password)
                default:
                    break
            }
        }
    }
    
}
