//
//  ServersServiceManager.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import PromiseKit

class ServersServiceManager: ServiceManager {
    func getServersList() -> Promise<[ServerModel]?> {
        return get("http://playground.tesonet.lt/v1/servers", parameters: nil, auth: true).then { responseData -> Promise<[ServerModel]?> in
            return .value(responseData.decode([ServerModel].self))
        }
    }
}
