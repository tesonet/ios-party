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
    
    internal var token : String? {
        let keychain = KeychainSwift()
        return keychain.get(Constants.tokenKey)
    }
    
    internal func didRequestLogOut(vc: ContainerViewController) {
        if let topController = vc.childViewControllers.first {
            let keychain = KeychainSwift()
            keychain.delete(Constants.userKey)
            keychain.delete(Constants.tokenKey)
            vc.dataHandler.dataSource.removeAll()
            topController.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
	}
        
    internal func containerVCdidRequestLogin(vc: ContainerViewController, username: String, password: String) {
        if let topController = vc.childViewControllers.first {
            topController.performSegue(withIdentifier: "loadingSegue", sender: self)
        }
        
        if let theToken = token, let theUserName = self.username {
            let userModel = UserModel(token:theToken, username: theUserName)
            didLogin(vc: vc, userModel: userModel)
            return
        }
        
        _ = NetworkingManager.login(userName: username, password: password)
        {[weak self] (outUserModel, outError) in
            if let error = outError {
                self?.showLoginAlert(error:error, vc: vc, name: username, password: password)
                return
            }
            self?.didLogin(vc:vc, userModel: outUserModel)
        }
    }
    
    private func didLogin(vc:ContainerViewController, userModel:UserModel?) {
        if let theUserModel = userModel {
            let keychain = KeychainSwift()
            keychain.set(theUserModel.username, forKey: Constants.userKey)
            keychain.set(theUserModel.token, forKey: Constants.tokenKey)
            
            getServersList(token: theUserModel.token, vc: vc)
        }
    }
    
    private func getServersList(token:String, vc:ContainerViewController) {
        _ = NetworkingManager.getServersList(token: token, completion: {[weak self] (outServerModels, outError) in
            if let error = outError {
                self?.showGetServersListAlert(error:error, vc:vc)
                return
            }
            if let servers = outServerModels {
                vc.dataHandler.dataSource.append(contentsOf:servers)
            }
            DispatchQueue.main.async {
                if let topController = vc.childViewControllers.first {
                    if !(topController is ListViewController) {
                        topController.performSegue(withIdentifier: "listViewControllerSegue", sender: self)
                    }
                }
            }
        })
    }
    
    private func showLoginAlert(error:Error, vc:ContainerViewController, name:String, password:String) {
        let message = getMessage(from: error)
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
    
    private func showGetServersListAlert(error:Error, vc:ContainerViewController) {
        let message = getMessage(from: error)
        DispatchQueue.main.async {
            let result = AlertUtil.showInformationalAlert(title:"Error", text: message,
                                                          buttonTitles: ["Try again", "OK"])
            switch result {
            case NSAlertFirstButtonReturn:
                self.getServersList(token: self.token!, vc: vc)
            default:
                break
            }
        }
    }
    
    private func getMessage(from error:Error) -> String {
        var message : String
        if error is ServerError {
            message = (error as! ServerError).description()
        } else {
            message = (error as NSError).localizedDescription
        }
        
        return message
    }
    
}
