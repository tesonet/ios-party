//
//  LoginManager.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation

class LoginManager{
    
    static func login(userName: String, password: String, loginSuccessful: @escaping (Bool) -> ()){
        let apiHandler = APIHandler()
        apiHandler.getToken(userName: userName, password: password) { (response) in
            if response.success{
                let credentialManager = CredentialManager()
                credentialManager.storeUserToken(token: response.token)
                ServerManager.updateServerList {
                    loginSuccessful(true)
                }
            }else{
                loginSuccessful(false)
            }
        }
    }
}
