//
//  ServersAPI.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import RxSwift
import SwiftyUserDefaults

extension API.Servers {
    struct GetAll: ModelArrayTargetType, MethodGET {
        typealias T = Auth
        var path: String { return "servers." }
    }
}
