//
//  AuthorizationResponse.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation

class AuthorizationResponse{
    
    let success : Bool
    let token : String
    
    init(success : Bool, token : String) {
        self.success = success
        self.token = token
    }
}
