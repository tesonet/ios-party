//
//  CredentialManager.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import KeychainSwift

class CredentialManager{
    
    static func storeUserToken(token : String){
        let keychain = KeychainSwift()
        keychain.set(token, forKey: Constants.USER_TOKEN_KEY)
    }
    
    static func getUserToken() throws -> String{
        let keychain = KeychainSwift()
        if let userToken = keychain.get(Constants.USER_TOKEN_KEY){
            return userToken
        }else{
            throw keychainError.tokenRetrievalError("Could not retrieve user token")
        }
    }
    
    static func deleteUserToken(){
        let keychain = KeychainSwift()
        keychain.delete(Constants.USER_TOKEN_KEY)
    }
}

enum keychainError: Error {
    case tokenRetrievalError(String)
    case tokenSetError(String)
}
