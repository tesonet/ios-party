//
//  ServersAPI.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation

extension API.Servers {
    
    struct GetAll: ModelArrayTargetType, MethodGET {
        typealias T = Server
        var path: String { return "/servers" }
    }
}
