//
//  HeadersAPI.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyUserDefaults

extension API.Headers {
    
    private static var token: String? {
        get { return Defaults[.token] }
        set { Defaults[.token] = newValue }
    }
    
    static func isLoggedIn() -> Bool {
        return token != nil
    }
    
    static func clear() {
        token = nil
    }
    
    static func authorize(token: String) {
        self.token = token
    }
    
    static var all: [String: String] {
        var all = [String: String]()
        
        if let token = token { all["Authorization"] = "Bearer \(token)" }
        
        return all
    }
}

private extension DefaultsKeys {
    static let token = DefaultsKey<String?> ("token")
}
