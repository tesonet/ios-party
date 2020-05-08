//
//  ServersAPI.swift
//  party
//
//  Created by Paulius on 08/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

extension API.Servers {
    
    struct Get: ModelArrayTargetType, MethodGET {
        typealias T = [Server]
        var path: String { "servers" }
    }
}
