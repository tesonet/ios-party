//
//  HeadersAPI.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation

extension API.Headers {
    
    static var all: [String: String] {
        guard let token = LoginService.token else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }
}
