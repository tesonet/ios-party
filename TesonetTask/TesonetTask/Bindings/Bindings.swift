//
//  Bindings.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class Bindings {
    
    let authManager: AuthManagerProtocol
    
    static let shared: Bindings = Bindings()
    
    fileprivate init() {
        self.authManager = AuthManager()
    }
    
    func logout() {
        authManager.cleanHeaders()
        
        guard let rootController = UIApplication.shared.keyWindow?
                                  .rootViewController?.children.first as? RootViewController else {
            return
        }
        
        rootController.changeRoot(type: .auth)
    }
}
