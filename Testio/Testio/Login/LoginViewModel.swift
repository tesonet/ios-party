//
//  LoginViewModel.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation

class LoginViewModel {

    private let authorizationPerformer: AuthorizationPerformingType
    
    init(authorizationPerformer: AuthorizationPerformingType) {
        self.authorizationPerformer = authorizationPerformer
    }
    
}
