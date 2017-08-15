//
//  AuthenticationAPI.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import RxSwift
import SwiftyUserDefaults

extension API.Authentication {
    struct Login: ModelTargetType, MethodPOST {
        typealias T = Auth
        let username, password: String
        var parameters: [String : Any]? { return ["username": email, "password": password] }
        var path: String { return "tokens" }
    }
}
