//
//  LoginManager.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation

class LoginManager{
    
    static func login(userName: String, password: String, loginSuccessful: @escaping (Bool, String) -> ()){
        let apiHandler = APIHandler()
        apiHandler.getToken(userName: userName, password: password) { (response) in
            if response.success{
                do{
                    try CredentialManager.storeUserToken(token: response.token)
                    loginSuccessful(true, "")
                }catch{
                    loginSuccessful(false, error.localizedDescription)
                }
            }else{
                loginSuccessful(false, "Incorrect credential information")
            }
        }
    }
    
    static func logout(){
        ServerManager.deleteServers()
        CredentialManager.deleteUserToken()
    }
}
